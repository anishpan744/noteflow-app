/**
 * Cloud Functions for NoteFlow & TaskCanvas
 * Implements the 5 functions specified in CLAUDE.md §7 (Firebase Functions v2).
 */
import {createHash} from "crypto";
import {lookup} from "dns/promises";
import {isIP} from "net";
import * as cheerio from "cheerio";
import {initializeApp} from "firebase-admin/app";
import {
  getFirestore,
  Timestamp,
  FieldValue,
  type Firestore,
} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onDocumentDeleted} from "firebase-functions/v2/firestore";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger} from "firebase-functions/v2";

initializeApp();
const db: Firestore = getFirestore();

// ─────────────────────────────────────────────────────────────────────────────
// Function 1 — generateRecurringTasks (daily 02:00 UTC)
// Generates upcoming task instances from /users/{uid}/recurringMasters.
// ─────────────────────────────────────────────────────────────────────────────

interface RecurrenceConfig {
  type: string; // daily | weekly | monthly | quarterly | halfYearly | annually | custom
  interval?: number;
  daysOfWeek?: number[]; // 1=Mon … 7=Sun
  dayOfMonth?: number;
  monthOfYear?: number;
  endDate?: Timestamp | null;
  endAfterCount?: number | null;
}

/** Compute occurrence dates within [from, until] for a recurrence config. */
function computeOccurrences(
  cfg: RecurrenceConfig,
  from: Date,
  until: Date,
): Date[] {
  const out: Date[] = [];
  const interval = Math.max(1, cfg.interval ?? 1);
  const cursor = new Date(from);
  cursor.setHours(0, 0, 0, 0);

  // Safety cap to avoid unbounded loops
  let guard = 0;
  const maxIterations = 400;

  while (cursor <= until && guard < maxIterations) {
    guard++;
    let matches = false;

    switch (cfg.type) {
      case "daily": {
        const days = Math.round(
          (cursor.getTime() - from.getTime()) / 86400000,
        );
        matches = days % interval === 0;
        break;
      }
      case "weekly": {
        // weekday: convert JS 0=Sun..6=Sat to 1=Mon..7=Sun
        const wd = cursor.getDay() === 0 ? 7 : cursor.getDay();
        matches = (cfg.daysOfWeek ?? []).includes(wd);
        break;
      }
      case "monthly":
        matches = cursor.getDate() === (cfg.dayOfMonth ?? from.getDate());
        break;
      case "quarterly":
        matches =
          cursor.getDate() === (cfg.dayOfMonth ?? from.getDate()) &&
          cursor.getMonth() % 3 === from.getMonth() % 3;
        break;
      case "halfYearly":
        matches =
          cursor.getDate() === (cfg.dayOfMonth ?? from.getDate()) &&
          cursor.getMonth() % 6 === from.getMonth() % 6;
        break;
      case "annually":
        matches =
          cursor.getDate() === (cfg.dayOfMonth ?? from.getDate()) &&
          cursor.getMonth() === ((cfg.monthOfYear ?? from.getMonth() + 1) - 1);
        break;
      case "custom": {
        const days = Math.round(
          (cursor.getTime() - from.getTime()) / 86400000,
        );
        matches = days % interval === 0;
        break;
      }
      default:
        matches = false;
    }

    if (matches) out.push(new Date(cursor));
    cursor.setDate(cursor.getDate() + 1);
  }
  return out;
}

export const generateRecurringTasks = onSchedule(
  {schedule: "0 2 * * *", timeZone: "UTC"},
  async () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const horizon = new Date(today);
    horizon.setDate(horizon.getDate() + 30);

    const usersSnap = await db.collection("users").get();
    let totalCreated = 0;

    for (const userDoc of usersSnap.docs) {
      const uid = userDoc.id;
      const mastersSnap = await db
        .collection("users")
        .doc(uid)
        .collection("recurringMasters")
        .where("nextGenerateDate", "<=", Timestamp.fromDate(today))
        .get();

      for (const masterDoc of mastersSnap.docs) {
        const master = masterDoc.data();
        const cfg = (master.recurrenceConfig ?? {}) as RecurrenceConfig;
        const template = (master.taskTemplate ?? {}) as Record<string, unknown>;
        let instanceCount = (master.instanceCount as number) ?? 0;
        const endAfter = cfg.endAfterCount ?? null;
        const endDate = cfg.endDate ? cfg.endDate.toDate() : null;

        const occurrences = computeOccurrences(cfg, today, horizon);
        const batch = db.batch();
        const tasksCol = db
          .collection("users")
          .doc(uid)
          .collection("tasks");

        for (const occ of occurrences) {
          if (endDate && occ > endDate) break;
          if (endAfter != null && instanceCount >= endAfter) break;

          const newRef = tasksCol.doc();
          batch.set(newRef, {
            ...template,
            dueDate: Timestamp.fromDate(occ),
            status: "notStarted",
            isMasterRecurring: false,
            masterTaskId: masterDoc.id,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
          });
          instanceCount++;
          totalCreated++;
        }

        batch.update(masterDoc.ref, {
          nextGenerateDate: Timestamp.fromDate(horizon),
          instanceCount,
        });
        await batch.commit();
      }
    }
    logger.info(`generateRecurringTasks: created ${totalCreated} task(s).`);
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// Function 2 — scrapeOpenGraph (callable)
// Fetches a URL, extracts OpenGraph metadata, caches in /ogCache for 24h.
// ─────────────────────────────────────────────────────────────────────────────

interface OgResult {
  title: string | null;
  description: string | null;
  imageUrl: string | null;
  siteName: string | null;
  favicon: string | null;
}

// SSRF guard configuration.
const MAX_REDIRECTS = 3;
const MAX_HTML_BYTES = 2 * 1024 * 1024; // 2 MB

function ipv4ToInt(ip: string): number {
  return ip.split(".").reduce((acc, o) => (acc << 8) + parseInt(o, 10), 0) >>> 0;
}

/** True for loopback, private, link-local, CGNAT, reserved and multicast IPv4. */
function isPrivateIPv4(ip: string): boolean {
  const n = ipv4ToInt(ip);
  const inRange = (base: string, bits: number): boolean => {
    const mask = bits === 0 ? 0 : (~0 << (32 - bits)) >>> 0;
    return (n & mask) === (ipv4ToInt(base) & mask);
  };
  return (
    inRange("0.0.0.0", 8) ||
    inRange("10.0.0.0", 8) ||
    inRange("100.64.0.0", 10) || // CGNAT
    inRange("127.0.0.0", 8) ||
    inRange("169.254.0.0", 16) || // link-local incl. 169.254.169.254 metadata
    inRange("172.16.0.0", 12) ||
    inRange("192.0.0.0", 24) ||
    inRange("192.168.0.0", 16) ||
    inRange("198.18.0.0", 15) ||
    inRange("224.0.0.0", 4) || // multicast
    inRange("240.0.0.0", 4) // reserved
  );
}

function isPrivateIPv6(ip: string): boolean {
  const addr = ip.toLowerCase();
  if (addr === "::1" || addr === "::") return true;
  if (addr.startsWith("fc") || addr.startsWith("fd")) return true; // unique-local
  if (/^fe[89ab]/.test(addr)) return true; // link-local fe80::/10
  const mapped = addr.match(/^::ffff:(\d+\.\d+\.\d+\.\d+)$/);
  if (mapped) return isPrivateIPv4(mapped[1]);
  return false;
}

function isPrivateIP(ip: string): boolean {
  const v = isIP(ip);
  if (v === 4) return isPrivateIPv4(ip);
  if (v === 6) return isPrivateIPv6(ip);
  return true; // unknown form → treat as unsafe
}

/** Validate protocol + reject hosts that resolve to private/internal IPs. */
async function assertPublicUrl(raw: string): Promise<URL> {
  let u: URL;
  try {
    u = new URL(raw);
  } catch {
    throw new HttpsError("invalid-argument", "Malformed URL.");
  }
  if (u.protocol !== "http:" && u.protocol !== "https:") {
    throw new HttpsError("invalid-argument", "Only http(s) URLs are allowed.");
  }
  const host = u.hostname;
  if (isIP(host)) {
    if (isPrivateIP(host)) {
      throw new HttpsError("permission-denied", "URL targets a private address.");
    }
    return u;
  }
  if (/^(localhost|.*\.local|.*\.internal)$/i.test(host)) {
    throw new HttpsError("permission-denied", "URL host is not allowed.");
  }
  const records = await lookup(host, {all: true});
  if (records.length === 0) {
    throw new HttpsError("unavailable", "Could not resolve host.");
  }
  for (const r of records) {
    if (isPrivateIP(r.address)) {
      throw new HttpsError("permission-denied", "URL resolves to a private address.");
    }
  }
  return u;
}

/** Read a response body, aborting if it exceeds the byte cap. */
async function readCapped(res: Response, maxBytes: number): Promise<string> {
  const reader = res.body?.getReader();
  if (!reader) return "";
  const chunks: Uint8Array[] = [];
  let total = 0;
  for (;;) {
    const {done, value} = await reader.read();
    if (done) break;
    if (value) {
      total += value.length;
      if (total > maxBytes) {
        await reader.cancel();
        throw new HttpsError("invalid-argument", "Response too large.");
      }
      chunks.push(value);
    }
  }
  return Buffer.concat(chunks).toString("utf-8");
}

/** Fetch HTML with manual redirect following, re-validating every hop. */
async function safeFetchHtml(startUrl: string): Promise<string> {
  let current = await assertPublicUrl(startUrl);
  for (let i = 0; i <= MAX_REDIRECTS; i++) {
    const res = await fetch(current, {
      headers: {"User-Agent": "NoteFlowBot/1.0 (+https://noteflow.app)"},
      redirect: "manual",
      signal: AbortSignal.timeout(15000),
    });

    if (res.status >= 300 && res.status < 400) {
      const loc = res.headers.get("location");
      if (!loc) throw new HttpsError("unavailable", "Redirect without location.");
      if (i === MAX_REDIRECTS) {
        throw new HttpsError("unavailable", "Too many redirects.");
      }
      current = await assertPublicUrl(new URL(loc, current).toString());
      continue;
    }

    if (!res.ok) {
      throw new HttpsError("unavailable", `Fetch failed: ${res.status}`);
    }

    const ctype = res.headers.get("content-type") ?? "";
    if (!/text\/html|application\/xhtml\+xml/i.test(ctype)) {
      throw new HttpsError("invalid-argument", "URL is not an HTML page.");
    }

    const lenHeader = res.headers.get("content-length");
    if (lenHeader && Number(lenHeader) > MAX_HTML_BYTES) {
      throw new HttpsError("invalid-argument", "Response too large.");
    }

    return readCapped(res, MAX_HTML_BYTES);
  }
  throw new HttpsError("unavailable", "Too many redirects.");
}

// NOTE: enforceAppCheck should be set to true here once the Flutter client
// initialises firebase_app_check and sends App Check tokens; enabling it before
// that would reject every call. Tracked as a follow-up.
export const scrapeOpenGraph = onCall(
  {cors: true, timeoutSeconds: 30},
  async (request): Promise<OgResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Authentication required.");
    }
    const url = (request.data?.url as string | undefined)?.trim();
    if (!url || !/^https?:\/\//i.test(url)) {
      throw new HttpsError("invalid-argument", "A valid http(s) url is required.");
    }

    const urlHash = createHash("sha256").update(url).digest("hex");
    const cacheRef = db.collection("ogCache").doc(urlHash);

    // Serve from cache if fresh (< 24h)
    const cached = await cacheRef.get();
    if (cached.exists) {
      const data = cached.data() as (OgResult & {fetchedAt?: Timestamp});
      const fetchedAt = data.fetchedAt?.toDate();
      if (fetchedAt && Date.now() - fetchedAt.getTime() < 24 * 3600 * 1000) {
        return {
          title: data.title ?? null,
          description: data.description ?? null,
          imageUrl: data.imageUrl ?? null,
          siteName: data.siteName ?? null,
          favicon: data.favicon ?? null,
        };
      }
    }

    let html: string;
    try {
      html = await safeFetchHtml(url);
    } catch (e) {
      if (e instanceof HttpsError) throw e;
      logger.warn(`scrapeOpenGraph fetch error for ${url}:`, e);
      throw new HttpsError("unavailable", "Could not fetch the URL.");
    }

    const $ = cheerio.load(html);
    const meta = (prop: string): string | null =>
      $(`meta[property="${prop}"]`).attr("content") ??
      $(`meta[name="${prop}"]`).attr("content") ??
      null;

    const origin = new URL(url).origin;
    const rawFavicon =
      $('link[rel="icon"]').attr("href") ??
      $('link[rel="shortcut icon"]').attr("href") ??
      "/favicon.ico";
    const favicon = rawFavicon.startsWith("http")
      ? rawFavicon
      : `${origin}${rawFavicon.startsWith("/") ? "" : "/"}${rawFavicon}`;

    const result: OgResult = {
      title: meta("og:title") ?? $("title").first().text() ?? null,
      description: meta("og:description") ?? meta("description"),
      imageUrl: meta("og:image"),
      siteName: meta("og:site_name") ?? new URL(url).hostname,
      favicon,
    };

    await cacheRef.set({
      ...result,
      url,
      fetchedAt: FieldValue.serverTimestamp(),
    });

    return result;
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// Function 3 — sendMorningDigest (daily 07:00 UTC)
// FCM push to users with settings.morningDigest = true.
// ─────────────────────────────────────────────────────────────────────────────

export const sendMorningDigest = onSchedule(
  {schedule: "0 7 * * *", timeZone: "UTC"},
  async () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const usersSnap = await db.collection("users").get();
    let sent = 0;

    for (const userDoc of usersSnap.docs) {
      const settings = (userDoc.data().settings ?? {}) as Record<string, unknown>;
      if (settings.morningDigest !== true) continue;

      const uid = userDoc.id;
      const tasksSnap = await db
        .collection("users").doc(uid).collection("tasks")
        .where("dueDate", ">=", Timestamp.fromDate(today))
        .where("dueDate", "<", Timestamp.fromDate(tomorrow))
        .get();

      if (tasksSnap.empty) continue;

      const titles = tasksSnap.docs
        .map((d) => d.data().title as string)
        .filter(Boolean)
        .slice(0, 3);

      const tokens = await getUserTokens(uid);
      if (tokens.length === 0) continue;

      await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: `Today: ${tasksSnap.size} task${tasksSnap.size === 1 ? "" : "s"}`,
          body: titles.join(" · "),
        },
        data: {type: "morning_digest"},
      });
      sent++;
    }
    logger.info(`sendMorningDigest: sent to ${sent} user(s).`);
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// Function 4 — sendOverdueNudge (every 2 hours)
// Re-alert on incomplete tasks past due, throttled to once per 2h per task.
// ─────────────────────────────────────────────────────────────────────────────

export const sendOverdueNudge = onSchedule(
  {schedule: "0 */2 * * *", timeZone: "UTC"},
  async () => {
    const now = new Date();
    const twoHoursAgo = new Date(now.getTime() - 2 * 3600 * 1000);
    const usersSnap = await db.collection("users").get();
    let nudged = 0;

    for (const userDoc of usersSnap.docs) {
      const settings = (userDoc.data().settings ?? {}) as Record<string, unknown>;
      if (settings.overdueNudge !== true) continue; // respect opt-out (default off)

      const uid = userDoc.id;
      const overdueSnap = await db
        .collection("users").doc(uid).collection("tasks")
        .where("dueDate", "<", Timestamp.fromDate(now))
        .get();

      const due = overdueSnap.docs.filter((d) => {
        const t = d.data();
        if (t.status === "done" || t.status === "cancelled") return false;
        const last = (t.lastNudgeAt as Timestamp | undefined)?.toDate();
        return !last || last < twoHoursAgo;
      });
      if (due.length === 0) continue;

      const tokens = await getUserTokens(uid);
      if (tokens.length === 0) continue;

      await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: `${due.length} overdue task${due.length === 1 ? "" : "s"}`,
          body: due.map((d) => d.data().title as string).filter(Boolean).slice(0, 3).join(" · "),
        },
        data: {type: "overdue_nudge"},
      });

      const batch = db.batch();
      for (const d of due) {
        batch.update(d.ref, {lastNudgeAt: FieldValue.serverTimestamp()});
      }
      await batch.commit();
      nudged++;
    }
    logger.info(`sendOverdueNudge: nudged ${nudged} user(s).`);
  },
);

// ─────────────────────────────────────────────────────────────────────────────
// Function 5 — cleanupDeletedUser (Firestore onDelete /users/{uid})
// Batch-deletes all sub-collections when a user document is deleted.
// ─────────────────────────────────────────────────────────────────────────────

export const cleanupDeletedUser = onDocumentDeleted(
  "users/{uid}",
  async (event) => {
    const uid = event.params.uid;
    const subcollections = [
      "categories",
      "notes",
      "tasks",
      "recurringMasters",
      "fcmTokens",
    ];

    await Promise.all(
      subcollections.map((name) =>
        deleteCollection(db.collection("users").doc(uid).collection(name)),
      ),
    );
    logger.info(`cleanupDeletedUser: purged data for ${uid}.`);
  },
);

// ── Helpers ───────────────────────────────────────────────────────────────────

async function getUserTokens(uid: string): Promise<string[]> {
  const snap = await db
    .collection("users").doc(uid).collection("fcmTokens").get();
  return snap.docs
    .map((d) => (d.data().token as string) ?? d.id)
    .filter(Boolean);
}

async function deleteCollection(
  col: FirebaseFirestore.CollectionReference,
  batchSize = 300,
): Promise<void> {
  let more = true;
  while (more) {
    const snap = await col.limit(batchSize).get();
    if (snap.empty) break;
    const batch = db.batch();
    snap.docs.forEach((d) => batch.delete(d.ref));
    await batch.commit();
    more = snap.size === batchSize;
  }
}
