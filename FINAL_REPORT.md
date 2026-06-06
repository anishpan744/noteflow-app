# NoteFlow & TaskCanvas — Final Report (v1.0, Android)

*Think clearly. Act precisely.*

Build target verified: **Android** (Pixel 7 emulator, Android 15, API 35).
Repo: https://github.com/anishpan744/noteflow-app · Firebase project: `noteflow-taskcanvas`

---

## 1. Phase completion

| Phase | Scope | Status |
|---|---|---|
| 0 | Environment setup | ✅ Complete |
| 1 | Project scaffold + Firebase config | ✅ Complete |
| 2 | Neural Glass design system | ✅ Complete |
| 3 | Freezed data models + codegen | ✅ Complete |
| 4 | Data layer (Drift + Firestore + repos + SyncService) | ✅ Complete (rules + indexes deployed) |
| 5 | Authentication (Firebase + Google Sign-In) | ✅ Code complete |
| 6 | Categories feature | ✅ Complete |
| 7 | Notes feature (flutter_quill) | ✅ Complete |
| 8 | Tasks & Calendar (month/week/day) | ✅ Complete |
| 9 | Cloud Functions (5) | ⚠️ Code complete; **deploy needs Blaze** |
| 10 | Notifications (local + FCM) | ✅ Complete |
| 11 | Settings | ✅ Complete |
| 12 | Unified Search | ✅ Complete |
| 13 | Windows desktop adaptations | ⏭️ **Deferred** (Windows build blocked) |
| 14 | App icon, splash, CI/CD, release build | ✅ Android done; Windows release deferred |
| 15 | Integration verification + this report | ✅ Complete (Android) |

---

## 2. Smoke-test results (Step 15.1)

Run on the Android emulator. Where end-to-end UI automation was unreliable
(soft-keyboard text entry via adb), the status reflects what was verified by
on-device rendering + `flutter analyze` + code review.

| # | Flow | Status | Notes |
|---|---|---|---|
| 1 | Sign in with Google → Notes | ⚠️ Code complete | Firebase Auth + Google Sign-In implemented. Not runnable on this emulator (Google OAuth WebView rejects keyboard input). Post-auth routing to `/notes` verified via a dev bypass. |
| 2 | Create category (color + icon) | ✅ Screens verified | Category list + form (16 swatches, module pills, icon grid) render and are wired to `CategoryController.create`. |
| 3 | Note → category → web link preview | ⚠️ Partial | Note editor + category assignment work. **Link OG preview requires `scrapeOpenGraph` (Blaze).** |
| 4 | Edit note → navigate away → autosaved | ✅ Verified | 500 ms debounce auto-save; "Saving…/Saved ✓" indicator. |
| 5 | Create task for today → Day + Month dot | ✅ Screens verified | Calendar month/week/day, day panel, task editor all render; dots/blocks wired to streams. |
| 6 | Weekly recurring task → 30-day instances | ⚠️ Partial | Recurrence picker complete. **Instance generation is `generateRecurringTasks` (Blaze).** |
| 7 | Mark task done → status across views | ✅ Verified | Status toggle in day panel + editor → `updateStatus`. |
| 8 | Offline create → online sync | ⚠️ Architecture in place | Drift-first writes + `SyncService` (connectivity flush) implemented; full Firestore round-trip needs real auth. |
| 9 | Windows 3-pane layout | ⏭️ Deferred | Phase 13 skipped; Windows build blocked. |
| 10 | Toggle dark/light theme | ✅ Verified live | Switched Dark→Light→Dark on device; persists. *Caveat below.* |

**App-wide verified live on device:** launch → auth redirect → 4-tab shell
(Notes/Tasks/Categories/Settings), Notes empty state, Tasks calendar + view
switcher, Task editor (priority/status/sub-tasks/recurrence), Settings (all 6
sections), Search screen, Android 13+ notification permission + `noteflow_tasks`
channel, and release-APK install.

---

## 3. Known limitations & deferred items

- **Cloud Functions not deployed** — the 5 functions (`generateRecurringTasks`,
  `scrapeOpenGraph`, `sendMorningDigest`, `sendOverdueNudge`,
  `cleanupDeletedUser`) build and lint cleanly but require the **Blaze** plan to
  deploy. Until then: no live OG link previews, no server-side recurring-task
  generation, no push digests/nudges. Local task reminders work (on-device).
- **Windows desktop** — `flutter build windows --release` fails: the
  `firebase_auth` Windows C++ plugin does not compile under MSVC on Flutter
  3.32. Phase 13 (3-pane + keyboard shortcuts) is deferred behind this fix.
- **Light/arctic theme & accent color are partial** — the Neural Glass widgets
  use fixed dark design tokens (`kBg*`, `kNeon`), so switching theme/accent
  recolors Material-default surfaces but not the custom glass UI. A design-token
  refactor (token set behind an `InheritedWidget`/theme extension) is needed for
  full theming.
- **Dev auth bypass** — `kDevBypassAuth` in `auth_providers.dart` exists for
  on-emulator verification without Google Sign-In. It is committed as `false`.
- **Security review applied** — `scrapeOpenGraph` is now auth-gated and
  SSRF-hardened (private-IP/redirect/content-type/size guards); `ogCache` is
  client-unreadable; `sendOverdueNudge` honours the `overdueNudge` opt-out.
  Outstanding: enable App Check (item 1) and refresh the `uuid` transitive dep.
- **Web** is not a target — Drift's native SQLite (FFI) doesn't compile for web;
  web support was added only for early previews.
- **Voice-to-text, Drive picker, PDF export, home-screen widget, app-lock
  gate-on-launch, Pomodoro/analytics charts** (spec §3 stretch items) are not
  implemented in v1.0.

---

## 4. Build artifacts

Release APKs (debug-signed fallback — supply `android/key.properties` for a real
upload key):

```
noteflow_app/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk   24.8 MB
noteflow_app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk     26.8 MB
noteflow_app/build/app/outputs/flutter-apk/app-x86_64-release.apk        28.0 MB
```

Verified installable on the emulator. **Windows EXE/MSIX: not built** (deferred).

CI: `.github/workflows/ci.yml` (analyze · test · build-android · build-windows
[continue-on-error]). Build jobs need repo secrets: `GOOGLE_SERVICES_JSON`,
`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`.

---

## 5. Estimated Firebase usage (free / Spark tier)

For personal / low-volume use, everything implemented fits the **free Spark**
tier comfortably:

| Service | Free allowance | Expectation |
|---|---|---|
| Auth (Google/Email) | Unlimited | ✅ Free |
| Firestore | 1 GiB · 50K reads / 20K writes / 20K deletes per day | ✅ Far under for a few users |
| Storage (note images) | 5 GB · 1 GB/day download | ✅ Free for typical use |
| FCM (receive) | Unlimited | ✅ Free |
| **Cloud Functions** | **Not on Spark** | ⛔ Needs **Blaze** (then 2M invocations/mo free) |

Enabling Blaze for the functions typically costs **~$0/month** at this scale
(within Blaze's always-free allowances); a card is required to enable it.

---

## 6. Recommended next steps (v1.1)

1. **Enable Blaze + deploy functions** → `firebase deploy --only functions`;
   unlocks OG previews, recurring generation, digests/nudges.
   - Before exposing the scraper publicly, **enable App Check**: add
     `firebase_app_check` to `main.dart` (Play Integrity on Android), register the
     provider in the Firebase console, then flip `enforceAppCheck: true` on
     `scrapeOpenGraph` (a `NOTE` marks the spot in `functions/src/index.ts`).
   - **Resolve transitive `uuid` advisories** by bumping `firebase-admin` /
     `firebase-functions` to a clean fixed path — do **not** `npm audit fix
     --force` (it downgrades `firebase-admin` to a breaking 10.x).
2. **Fix Windows Firebase build** (pin/patch `firebase_auth` Windows, or
   conditionally exclude on Windows) → then do **Phase 13** (3-pane + Ctrl+N/F/S
   shortcuts) and the Windows release.
3. **Theme-token refactor** so light/arctic + accent fully recolor the glass UI.
4. **Real upload keystore** via `android/key.properties` + CI secrets; ship a
   Play Store AAB (`flutter build appbar`).
5. **Widget/integration tests** to back the CI `test` job (currently a
   placeholder).
6. Implement deferred spec stretch features (export/PDF, analytics, widget,
   voice-to-text) as prioritized.

---

*Generated at Phase 15 handover. Phases 0–12, 14 (Android), and 15 complete and
pushed to `main`.*
