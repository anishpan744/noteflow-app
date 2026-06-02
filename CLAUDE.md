# CLAUDE.md — NoteFlow & TaskCanvas
## Master Build Instructions for Claude Code Agentic Engineering

---

> **HOW THIS DOCUMENT WORKS**
>
> You are the engineering agent for this project. Read every section of this
> document before doing anything. Then follow the **Execution Protocol** below
> strictly. Never skip steps. Never write code without explicit approval.
>
> When you reach a step that requires approval, stop, present your plan clearly,
> and wait for the human to type **"approved"**, **"approved with changes: …"**,
> or **"skip"** before proceeding.

---

## 0. Execution Protocol (Read First — Always)

```
FOR EVERY PHASE AND STEP:
  1. READ the step description in full.
  2. PRESENT a brief plan: what you will create/change and why.
  3. LIST any files you intend to create or modify.
  4. WAIT for human approval before writing a single line of code.
  5. IMPLEMENT exactly what was approved.
  6. VERIFY: run the relevant check command and show output.
  7. SUMMARISE what was done and confirm readiness for next step.
```

**Hard Rules:**
- Never modify an existing file without explaining the change and getting approval.
- Never change the data schema (Firestore collections, Drift tables, model fields)
  without a dedicated schema-change approval step.
- If you discover a dependency conflict or architectural issue mid-step, STOP,
  report it clearly, and ask how to proceed — do not silently work around it.
- If a step produces errors you cannot resolve in two attempts, STOP and report
  the exact error with your diagnosis. Do not loop endlessly.
- All approval checkpoints are marked with: `## ⏸ APPROVAL CHECKPOINT`

---

## 1. Project Identity

| Field | Value |
|---|---|
| App Name | NoteFlow & TaskCanvas |
| Tagline | *Think clearly. Act precisely.* |
| Platform targets | Android (APK + Play Store AAB), Windows 11 (MSIX + portable EXE) |
| Primary stack | Flutter 3.x · Dart · Firebase Firestore · Firebase Auth |
| State management | Riverpod 2.x (riverpod_generator + riverpod_annotation) |
| Local cache | Drift (SQLite ORM) for offline-first support |
| Backend functions | Firebase Cloud Functions (Node.js / TypeScript) |
| Notifications | FCM (push) + flutter_local_notifications (scheduled local) |
| Auth | Firebase Auth — Google Sign-In (primary), Email/Password (fallback) |

---

## 2. Futuristic UI Design System

> The entire app must feel like software from 10 years in the future.
> Every screen, widget, and transition must reflect this design language.
> Do not deviate. Do not default to stock Material widgets without customisation.

### 2.1 Design Philosophy

**Aesthetic Direction: "Neural Glass"**

Imagine the UI of an AI research lab's internal tool — obsidian surfaces,
electric-blue data streams, glass morphism cards with depth, motion that
feels alive but never distracting. The interface breathes. It responds.
It feels *intelligent*.

Key qualities:
- **Dark-first**: Deep space backgrounds (`#050810`, `#080D1A`) with
  luminous accents. Light theme is an inverted "arctic" variant.
- **Glass morphism**: Cards use `BackdropFilter` blur + semi-transparent
  fills + subtle inner glow borders.
- **Neon accent system**: Electric blue `#00D4FF` as primary data color,
  violet `#7B61FF` for tasks, teal `#00FFB3` for success states,
  amber `#FFB800` for warnings/priority, crimson `#FF3366` for danger/overdue.
- **Typography**: `Rajdhani` (display headings — angular, technical),
  `DM Sans` (body text — humanist clarity), `JetBrains Mono` (code,
  timestamps, metadata). Import via Google Fonts package.
- **Motion**: All transitions use custom `CurvedAnimation` with
  `Curves.easeOutExpo`. Page transitions: horizontal slide with fade.
  Cards: staggered `FadeTransition` + `SlideTransition` on entry.
  Buttons: scale + glow pulse on tap.
- **Iconography**: `Phosphor Icons` Flutter package for sharp, consistent
  two-weight icons. Never use default Material icons without wrapping.
- **Grid and spacing**: 8px base unit. All padding/margin is a multiple of 8.
  Section headers have 24px top clearance.

### 2.2 Color Tokens (define in `lib/core/design/tokens.dart`)

```dart
// Background hierarchy
kBg0      = Color(0xFF050810)   // deepest — page background
kBg1      = Color(0xFF080D1A)   // surface — cards, drawers
kBg2      = Color(0xFF0D1424)   // raised — input fields, list items
kBg3      = Color(0xFF141B2E)   // overlay — tooltips, menus

// Accent / data colors
kNeon     = Color(0xFF00D4FF)   // primary accent — electric blue
kViolet   = Color(0xFF7B61FF)   // tasks module accent
kTeal     = Color(0xFF00FFB3)   // success / done
kAmber    = Color(0xFFFFB800)   // warning / priority
kCrimson  = Color(0xFFFF3366)   // danger / overdue / delete

// Glass card
kGlassFill   = Color(0x1AFFFFFF)  // 10% white fill
kGlassBorder = Color(0x33FFFFFF)  // 20% white border
kGlowBlue    = Color(0x2600D4FF)  // 15% blue for inner glow

// Text
kTextPrimary   = Color(0xFFF0F4FF)
kTextSecondary = Color(0xFF8892AA)
kTextMuted     = Color(0xFF4A5568)

// Arctic light theme overrides (kLightBg0 etc.) — define analogous set
// with near-white backgrounds and deep navy text
kLightBg0   = Color(0xFFF0F4FF)
kLightBg1   = Color(0xFFE8EEF8)
kLightBg2   = Color(0xFFDDE5F5)
kNeonLight  = Color(0xFF0066CC)  // darkened for legibility on light
```

### 2.3 Glass Card Widget (build once, use everywhere)

```
GlassCard({
  child,
  blur: 12.0,
  borderRadius: 16.0,
  glowColor: kNeon (optional),
  padding: EdgeInsets.all(16),
})
```

Implementation: `ClipRRect` → `BackdropFilter(ImageFilter.blur)` →
`Container(decoration: BoxDecoration(color: kGlassFill, border: Border.all(kGlassBorder), borderRadius: ..., boxShadow: [glowShadow]))`.

### 2.4 Neon Button

```
NeonButton({ label, icon, onTap, color: kNeon, size: normal|small|large })
```

On tap: scale to 0.96 + radiate a 200ms glow pulse using `AnimatedContainer`.
Default state: dark bg with colored border + icon. Hover (desktop): bg
brightens to 15% of accent color.

### 2.5 Calendar Visual Spec

- **Month grid**: hexagonal-corner cells, today cell has animated pulsing
  neon ring, task-filled days show stacked micro-dots in category colors.
- **Week view**: vertical swimlane columns, each column header has date +
  day abbreviation, glass card column for today.
- **Day view**: horizontal time ruler on left, task blocks are gradient
  pills (`accent color → transparent`), current time indicator is an
  animated neon line with a pulsing dot.
- **Transitions**: swiping between days/weeks animates with a 3D page-curl
  effect using `AnimationController` + `Transform.perspective`.

### 2.6 Note Card Visual Spec

- Glass card with a thin left border strip in the category color.
- Title in `Rajdhani` 16pt, body preview in `DM Sans` 13pt `kTextSecondary`.
- Bottom row: category chips (pill shape, 20% opacity fill of category
  color + matching text), link-count icon, pin icon if pinned.
- Hover (desktop): card lifts 4px + glow intensifies.
- Long-press (mobile): haptic feedback + selection mode with checkboxes.

### 2.7 Splash & Onboarding

- Splash: black screen, animated logo — a hexagonal node network that
  assembles into the app mark, then fades to login screen.
- Login: full-bleed animated particle background (CustomPainter with
  floating dots connected by thin lines — think neural network visualization).
  Google Sign-In button: `NeonButton` with Google logo.

---

## 3. Full Feature Specification

### MODULE A — SMART NOTE TAKER

#### A1. Core Note Management
- Create, edit, delete notes with title + rich-text body (flutter_quill).
- Assign notes to one or more **Categories** (shared with Tasks module).
- Each category has a **color flag** (hex color picker + 16 presets).
- **Pin** notes to top. **Archive** without deletion. **Trash** with 30-day
  auto-purge and restore.
- Duplicate note as draft. Save note as reusable template.

#### A2. Rich Content & Attachments
- Inline **web links** with auto-fetched OpenGraph preview card
  (title, favicon, description — fetched via Cloud Function).
- **Google Drive links**: show file name + type icon.
- **Facebook, Instagram, X (Twitter)** post links: store URL + OG preview.
- **Image attachments**: upload from device → stored in Firebase Storage,
  URL saved in note document.
- **Google Drive image picker**: browse Drive files within app using
  Google Drive Picker API (web OAuth flow via url_launcher).
- **Voice-to-text**: record audio → device Speech API → transcribed body.
- **Contextual Info Fields**: user-defined key-value pairs per note
  (e.g. `Project: Alpha`, `Contact: Ravi`).

#### A3. Formatting & Editor (flutter_quill)
- Bold, italic, underline, strikethrough.
- Font size selector.
- Text highlight colors (6 options).
- Bullet list, numbered list, checklist (inline to-do checkboxes).
- Code block with syntax highlight.
- Inline tables.
- Markdown toggle (render / raw).

#### A4. Organisation & Discovery
- **Full-text search** across title + body.
- **Filter by category**, **filter by color**, **filter by tag**.
- **Tags**: freeform hashtags per note (displayed as chips).
- **Sort**: date modified, date created, title A–Z, manual drag order.
- **Smart folders**: Recently Edited (last 7 days), Starred, Archived.
- **Linked notes**: bi-directional wiki-style links between notes.

#### A5. Sharing & Export
- Share note as read-only link (Firebase Dynamic Links).
- Export single note or category as PDF.
- Export as Markdown / plain text.
- One-tap copy to clipboard.
- Share via OS share sheet (WhatsApp, email, etc.).

---

### MODULE B — TO-DO & TASK TRACKER

#### B1. Core Task Management
- Create, edit, delete tasks with title, description, due date, due time.
- Assign to categories (color-flagged, shared with Notes).
- **Priority**: None / Low / Medium / High / Critical — colored badge icons.
- **Status**: Not Started / In Progress / Blocked / Done / Cancelled.
- **Sub-tasks**: nested checklist + auto-calculated progress bar.
- **Contextual Info Fields**: same key-value system as Notes.
- **Link attachments**: same web/Drive/social link support.

#### B2. Calendar Views
- **Month view**: grid calendar, today pulsing neon ring, task dots per day.
- **Week view**: 7-column swimlane, today glass-highlighted.
- **Day view**: time-slot timeline, current-time neon indicator.
- **Task list panel**: slide-up bottom sheet for selected day's tasks,
  sorted by time then priority, overdue tasks in crimson.
- **Agenda view**: flat chronological list — Next 7 / 30 / 90 days filter.
- **Drag-to-reschedule**: drag task pill to new slot in day/week view.
- **Today** always highlighted across all views.
- **Overdue** tasks shown in crimson in all views.

#### B3. Recurring Tasks
| Type | Config |
|---|---|
| Daily | Every N days |
| Weekly | Selected day(s) of week, every N weeks |
| Monthly | By date (15th) or relative day (2nd Tuesday) |
| Quarterly | Every 3 months on date |
| Half-Yearly | Every 6 months on date |
| Annually | Every year on date |
| Custom | Every N days/weeks/months (user-defined) |

- Each recurring type supports:
  - **End date**: series stops after this date.
  - **End after N occurrences**: stops after N completions.
  - **No end**: runs indefinitely.
- Edit options: *This event only* / *This and future events* / *All events*.
- **Skip one occurrence** without affecting the series.
- Visual badge on calendar and task card for recurring tasks.

#### B4. Reminders & Notifications
- Push notification at task due time (FCM + local_notifications).
- Pre-task reminder: 15 min / 30 min / 1 hr / 1 day before.
- **Morning digest**: daily push at configurable time listing today's tasks.
- **Overdue nudge**: re-alert every 2 hours if task incomplete.
- Notification snooze: 10 min / 1 hr / Tomorrow.
- Email reminder via Cloud Function (optional, user opt-in).

#### B5. Productivity & Analytics
- Completion rate chart (bar chart — weekly/monthly).
- Category breakdown (donut chart).
- Streak tracker (consecutive completion days).
- Focus mode: Pomodoro timer attached to a task.
- Time tracking: log actual time spent per task.
- Overdue summary dashboard card.
- Android home-screen widget (next 3 tasks).

---

### MODULE C — SHARED PLATFORM FEATURES

#### C1. Authentication & Sync
- Google Sign-In (primary) via Firebase Auth.
- Email/Password auth (fallback).
- Real-time cross-device sync via Firestore snapshot listeners.
- **Offline mode**: Drift SQLite cache; all reads/writes work offline;
  sync queue flushes to Firestore on reconnect.
- Conflict resolution: last-write-wins with timestamp; warn on same-second edits.
- Account settings: display name, photo, notification preferences.

#### C2. UI / UX & Personalisation
- **Light / Dark / System** theme — three-way toggle.
- Accent color selection (5 preset neon palettes).
- Font size: Small / Medium / Large / Extra Large.
- Responsive layout: phone (single column) → tablet (split) → desktop (3-pane).
- Full keyboard shortcuts on Windows desktop.
- Drag-and-drop reorder for notes and tasks within a category.

#### C3. Security & Privacy
- Firestore Security Rules: per-user data isolation.
- App lock: PIN or biometric (fingerprint / Windows Hello).
- Full data export: JSON + attachments ZIP.
- Account deletion: cascade-purges all Firestore data + Firebase Auth record.

---

## 4. Data Architecture

### 4.1 Firestore Collection Schema

```
/users/{uid}
  displayName, email, photoUrl, createdAt, settings{}

/users/{uid}/categories/{catId}
  name, colorHex, module (note|task|shared), iconName, sortOrder,
  archivedAt, createdAt, updatedAt

/users/{uid}/notes/{noteId}
  title, bodyJson, categoryIds[], tags[], links[], attachmentUrls[],
  isPinned, isArchived, contextFields{}, createdAt, updatedAt

/users/{uid}/tasks/{taskId}
  title, description, categoryIds[], dueDate (Timestamp), dueTime (String HH:mm),
  priority (none|low|medium|high|critical),
  status (notStarted|inProgress|blocked|done|cancelled),
  subTasks[], links[], recurrence{}, reminders[], contextFields{},
  isMasterRecurring (bool), masterTaskId (String?),
  createdAt, updatedAt

/users/{uid}/tasks/{taskId}/recurrence  [embedded map, not sub-collection]
  type, interval, daysOfWeek[], dayOfMonth, monthOfYear,
  endDate (Timestamp?), endAfterCount (int?), instanceCount (int)

/users/{uid}/recurringMasters/{masterId}
  taskTemplate{}, recurrenceConfig{}, nextGenerateDate (Timestamp),
  instanceCount, createdAt
```

> ⚠️ **Schema Freeze Rule**: Any addition or change to the above schema
> requires a dedicated `## ⏸ APPROVAL CHECKPOINT — SCHEMA CHANGE` before
> the change is made. State: which collection, which field, what type,
> why it is needed, and what migration (if any) is required.

### 4.2 Drift Local Tables

Mirror the Firestore schema in SQLite via Drift. All JSON fields stored
as TEXT (serialised). Add `syncStatus` column (`pending | synced | deleted`)
to each table for offline queue management.

### 4.3 Offline Sync Strategy

```
WRITE:
  1. Write to Drift immediately → UI updates instantly.
  2. Set syncStatus = 'pending'.
  3. If online → write to Firestore → set syncStatus = 'synced'.
  4. If offline → SyncService queues the write.
  5. On connectivity restored → SyncService flushes queue.

READ:
  1. Always read from Drift stream (instant, cached).
  2. Firestore onSnapshot listener runs in background.
  3. On snapshot delta → upsert into Drift → Riverpod rebuilds UI.
```

---

## 5. Flutter Project Structure

```
noteflow_app/
├── android/                        # Android platform code
│   └── app/google-services.json   # ← you place this (Phase 0)
├── windows/                        # Windows platform code
├── functions/                      # Firebase Cloud Functions (TypeScript)
├── firestore.rules
├── firestore.indexes.json
├── firebase.json
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── design/
│   │   │   ├── tokens.dart         # Color tokens (Section 2.2)
│   │   │   ├── typography.dart     # Font theme (Rajdhani, DM Sans, JetBrains Mono)
│   │   │   ├── theme.dart          # ThemeData light + dark
│   │   │   └── animations.dart     # Shared curves, durations, transitions
│   │   ├── widgets/
│   │   │   ├── glass_card.dart     # GlassCard widget
│   │   │   ├── neon_button.dart    # NeonButton widget
│   │   │   ├── color_flag_chip.dart
│   │   │   ├── link_preview_card.dart
│   │   │   └── phosphor_icon.dart  # Thin wrapper for Phosphor Icons
│   │   ├── router.dart             # GoRouter configuration
│   │   ├── responsive_layout.dart  # Phone/tablet/desktop breakpoints
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       └── debouncer.dart
│   ├── models/
│   │   ├── category.dart           # Freezed model
│   │   ├── note.dart
│   │   ├── task.dart
│   │   ├── sub_task.dart
│   │   ├── recurrence.dart
│   │   └── link_attachment.dart
│   ├── data/
│   │   ├── local/
│   │   │   ├── app_database.dart   # Drift @DriftDatabase
│   │   │   ├── notes_dao.dart
│   │   │   ├── tasks_dao.dart
│   │   │   └── categories_dao.dart
│   │   ├── remote/
│   │   │   ├── firestore_notes_datasource.dart
│   │   │   ├── firestore_tasks_datasource.dart
│   │   │   └── firestore_categories_datasource.dart
│   │   └── repositories/
│   │       ├── note_repository.dart
│   │       ├── task_repository.dart
│   │       ├── category_repository.dart
│   │       └── sync_service.dart
│   └── features/
│       ├── auth/
│       │   ├── auth_providers.dart
│       │   └── login_screen.dart   # Particle background + NeonButton
│       ├── notes/
│       │   ├── note_providers.dart
│       │   ├── note_list_screen.dart
│       │   └── note_editor_screen.dart
│       ├── tasks/
│       │   ├── task_providers.dart
│       │   ├── calendar_screen.dart
│       │   ├── task_list_panel.dart
│       │   ├── task_editor_screen.dart
│       │   └── recurrence_picker_widget.dart
│       ├── categories/
│       │   ├── category_providers.dart
│       │   ├── category_list_screen.dart
│       │   └── category_form.dart
│       ├── search/
│       │   └── search_screen.dart
│       └── settings/
│           └── settings_screen.dart
```

---

## 6. All Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
  firebase_analytics: ^11.0.0
  firebase_crashlytics: ^4.0.0
  firebase_messaging: ^15.0.0

  # Auth
  google_sign_in: ^6.2.0

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^14.0.0

  # Local database
  drift: ^2.18.0
  drift_flutter: ^0.1.0
  sqlite3_flutter_libs: ^0.5.0

  # Rich text editor
  flutter_quill: ^10.0.0

  # Calendar
  table_calendar: ^3.1.0

  # Notifications
  flutter_local_notifications: ^17.0.0

  # File handling
  file_picker: ^8.0.0
  image_picker: ^1.1.0

  # Security
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.3.0

  # UI & Design
  google_fonts: ^6.2.0          # Rajdhani, DM Sans
  phosphor_flutter: ^2.1.0      # Phosphor icons
  flutter_colorpicker: ^1.1.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0               # Loading skeletons
  lottie: ^3.1.0                # Animated splash/empty states
  fl_chart: ^0.67.0             # Analytics charts

  # Connectivity & utils
  connectivity_plus: ^6.0.0
  intl: ^0.19.0
  uuid: ^4.4.0
  url_launcher: ^6.3.0
  share_plus: ^9.0.0
  path_provider: ^2.1.0

  # Code generation (annotated)
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0
  riverpod_annotation: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
  drift_dev: ^2.18.0
  flutter_launcher_icons: ^0.13.0
  flutter_native_splash: ^2.4.0

flutter_launcher_icons:
  android: true
  ios: false
  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"
    icon_size: 48
  image_path: "assets/icon/app_icon.png"

flutter_native_splash:
  color: "#050810"
  image: assets/splash/logo_animated.png
  android: true
  windows: false
```

---

## 7. Firebase Cloud Functions Specification

Location: `functions/src/index.ts`

### Function 1 — `generateRecurringTasks`
- **Trigger**: Pub/Sub scheduled, runs daily at `02:00 UTC`.
- **Logic**:
  1. Query all `/users/{uid}/recurringMasters` where `nextGenerateDate <= today`.
  2. For each master: compute next occurrences for 30 days ahead.
  3. Write each occurrence as a task doc under `/users/{uid}/tasks/{newId}`.
  4. Update `masterTask.nextGenerateDate` and increment `instanceCount`.
  5. Stop if `endDate` has passed or `instanceCount >= endAfterCount`.

### Function 2 — `scrapeOpenGraph`
- **Trigger**: `https.onCall`.
- **Input**: `{ url: string }`.
- **Logic**: Fetch URL, parse with `cheerio`, extract OG tags.
  Cache result in `/ogCache/{urlHash}` for 24 hours.
- **Output**: `{ title, description, imageUrl, siteName, favicon }`.

### Function 3 — `sendMorningDigest`
- **Trigger**: Pub/Sub scheduled, runs daily at `07:00 UTC`.
- **Logic**: Per user with `morningDigest: true` in settings:
  fetch today's tasks, send FCM with count and first 3 task titles.

### Function 4 — `sendOverdueNudge`
- **Trigger**: Pub/Sub scheduled, runs every 2 hours.
- **Logic**: Find incomplete tasks past `dueDate`; send FCM if not
  nudged in last 2 hours (track `lastNudgeAt` on task doc).

### Function 5 — `cleanupDeletedUser`
- **Trigger**: `firestore.onDocumentDeleted('/users/{uid}')`.
- **Logic**: Batch-delete all sub-collections in parallel.

---

## 8. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // OG cache — readable by any authenticated user, not writable from client
    match /ogCache/{docId} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    // All user data — strictly scoped to owner
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null
                         && request.auth.uid == uid;
    }

    // Deny everything else
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## 9. Build Phases (Sequential)

Each phase contains numbered steps. Each step requires approval before
implementation. Do not start Phase N+1 until Phase N is fully verified.

---

### PHASE 0 — Environment Setup & Prerequisites

> Goal: Verify and install all required tools. No Flutter project is created
> yet. All tooling must be confirmed working before project creation.

**Step 0.1 — Detect OS and existing tools**

Check which of the following are already installed:
- Flutter SDK (`flutter --version`)
- Dart SDK (bundled with Flutter)
- Android Studio or Android SDK command-line tools
- Java JDK 17+ (`java -version`)
- Node.js 18+ (`node --version`)
- npm (`npm --version`)
- Firebase CLI (`firebase --version`)
- Git (`git --version`)

Report findings. For each missing tool, state the install command.

## ⏸ APPROVAL CHECKPOINT 0.1
Present: list of installed vs missing tools with install commands.
Wait for approval before installing anything.

**Step 0.2 — Install missing tools**

Install each missing tool using the approved commands.
- Flutter: download and extract SDK; add to PATH.
- Android SDK: install via `sdkmanager` or Android Studio.
- JDK 17: install via package manager (winget on Windows, apt on Linux).
- Node.js 18+: install via nvm or direct download.
- Firebase CLI: `npm install -g firebase-tools`.

After installation, re-run all version checks and confirm.

## ⏸ APPROVAL CHECKPOINT 0.2
Present: confirmation of all tools installed with versions.

**Step 0.3 — Install FlutterFire CLI and Dart global tools**

```bash
dart pub global activate flutterfire_cli
dart pub global activate build_runner
```

Add Dart pub global bin to PATH if not present.

## ⏸ APPROVAL CHECKPOINT 0.3

**Step 0.4 — Firebase project configuration (human-assisted)**

This step requires the human to:
1. Create a Firebase project at https://console.firebase.google.com
2. Enable: Firestore, Firebase Auth (Google + Email/Password),
   Firebase Storage, Firebase Messaging, Firebase Analytics.
3. Download `google-services.json` for Android.
4. Note the Firebase project ID for `flutterfire configure`.

Present checklist to human. Wait for confirmation that Firebase project
is ready and `google-services.json` is available.

## ⏸ APPROVAL CHECKPOINT 0.4
Human confirms Firebase project is ready.

---

### PHASE 1 — Project Scaffold

**Step 1.1 — Create Flutter project**

```bash
flutter create --org com.noteflow --platforms=android,windows noteflow_app
cd noteflow_app
```

Verify: `flutter doctor -v` shows no critical issues for Android and Windows.

## ⏸ APPROVAL CHECKPOINT 1.1

**Step 1.2 — Configure pubspec.yaml**

Replace the generated `pubspec.yaml` with the full dependency list from
Section 6. Add assets configuration:

```yaml
flutter:
  assets:
    - assets/icon/
    - assets/splash/
    - assets/lottie/
    - assets/fonts/
```

Run `flutter pub get`. Resolve any version conflicts and report.

## ⏸ APPROVAL CHECKPOINT 1.2

**Step 1.3 — FlutterFire configuration**

```bash
firebase login
flutterfire configure --project=YOUR_PROJECT_ID
```

This generates `lib/firebase_options.dart`.
Place `google-services.json` in `android/app/`.

## ⏸ APPROVAL CHECKPOINT 1.3

**Step 1.4 — Android manifest permissions**

Add to `android/app/src/main/AndroidManifest.xml`:
- `INTERNET`
- `RECEIVE_BOOT_COMPLETED` (for scheduled notifications)
- `VIBRATE`
- `USE_BIOMETRIC`, `USE_FINGERPRINT`
- `SCHEDULE_EXACT_ALARM` (Android 12+)
- FCM service and intent filters
- Google Sign-In `meta-data` with Web Client ID

## ⏸ APPROVAL CHECKPOINT 1.4

**Step 1.5 — Windows platform setup**

- Add `google_sign_in_windows` to pubspec if not included.
- Add OAuth Desktop Client ID to `windows/runner/main.cpp` via
  `google_sign_in_windows` package instructions.
- Configure `windows/runner/Runner.rc` with app name and version.

## ⏸ APPROVAL CHECKPOINT 1.5

---

### PHASE 2 — Design System

> Goal: Build the complete design system before any feature screens.
> Every screen will use these tokens and widgets.

**Step 2.1 — Color tokens and typography**

Create:
- `lib/core/design/tokens.dart` — all color tokens from Section 2.2.
- `lib/core/design/typography.dart` — TextTheme using `google_fonts`:
  - displayLarge → Rajdhani, 32pt, w700
  - headlineMedium → Rajdhani, 24pt, w600
  - bodyLarge → DM Sans, 16pt, w400
  - bodySmall → DM Sans, 13pt, w400
  - labelSmall → JetBrains Mono, 11pt, w400 (timestamps, metadata)
- `lib/core/design/animations.dart` — shared:
  - `kDurationFast` = 150ms, `kDurationMed` = 300ms, `kDurationSlow` = 600ms
  - `kCurveOut` = Curves.easeOutExpo
  - `kCurveIn` = Curves.easeInExpo
  - `kCurveSpring` = Curves.elasticOut
  - `pageRouteTransition()` factory function → slide + fade CustomTransitionPage

## ⏸ APPROVAL CHECKPOINT 2.1

**Step 2.2 — ThemeData**

Create `lib/core/design/theme.dart`:
- `darkTheme`: uses `kBg0` as scaffold background, `kNeon` as primary seed,
  no default card elevation (cards use GlassCard), no AppBar elevation.
- `lightTheme`: arctic variant using `kLight*` tokens.
- Both themes apply the typography from Step 2.1.
- `ThemeNotifier` (Riverpod StateProvider<ThemeMode>) stored in SharedPreferences.

## ⏸ APPROVAL CHECKPOINT 2.2

**Step 2.3 — GlassCard widget**

Build `lib/core/widgets/glass_card.dart` per Section 2.3 spec.
Write a simple test screen `lib/core/widgets/_preview.dart`
that shows 3 GlassCards with different glow colors so the human
can visually verify before proceeding.

## ⏸ APPROVAL CHECKPOINT 2.3

**Step 2.4 — NeonButton widget**

Build `lib/core/widgets/neon_button.dart` per Section 2.4 spec.
Add to preview screen.

## ⏸ APPROVAL CHECKPOINT 2.4

**Step 2.5 — Shared micro-widgets**

Build:
- `ColorFlagChip`: pill-shaped, category color fill at 20% opacity + border.
- `PhosphorIcon` wrapper: thin wrapper around `PhosphorIconsRegular` with
  optional neon glow effect.
- `LinkPreviewCard`: displays OG preview (image, title, domain, favicon).
- `ContextFieldRow`: key-value pair display row with edit capability.
- `StaggeredList`: wraps a list, animates each child in with 50ms stagger.

## ⏸ APPROVAL CHECKPOINT 2.5

**Step 2.6 — Responsive layout shell**

Build `lib/core/responsive_layout.dart`:
- `phone` < 600px: `Scaffold` with `BottomNavigationBar` (4 tabs:
  Notes, Tasks, Categories, Settings). Tab icons: Phosphor icons.
- `tablet` 600–1200px: `Scaffold` with `NavigationRail` (left).
- `desktop` > 1200px: `Scaffold` with full left sidebar (120px wide)
  showing labels below icons.

Build `lib/core/router.dart` using GoRouter:
- Routes: `/login`, `/notes`, `/notes/:id/edit`, `/tasks`,
  `/tasks/:id/edit`, `/categories`, `/settings`, `/search`.
- Auth redirect: watch `authStateProvider`; if null → redirect to `/login`.

## ⏸ APPROVAL CHECKPOINT 2.6

Run: `flutter run -d <android-emulator>` with the preview screen.
Confirm design system is rendering correctly before Phase 3.

---

### PHASE 3 — Data Models & Code Generation

**Step 3.1 — Freezed models**

Create all models in `lib/models/` as described in Section 4.1.
Each model must have:
- `@freezed` annotation.
- `fromJson` / `toJson` via `json_serializable`.
- `fromFirestore(DocumentSnapshot)` and `toFirestore()` methods.
- `copyWith` (auto-generated by freezed).

Models to create: `Category`, `Note`, `Task`, `SubTask`,
`Recurrence`, `LinkAttachment`.

## ⏸ APPROVAL CHECKPOINT 3.1
Present model field list for review before writing code.

**Step 3.2 — Run code generation**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Fix any generation errors. Confirm all `.freezed.dart` and `.g.dart`
files are created.

## ⏸ APPROVAL CHECKPOINT 3.2

---

### PHASE 4 — Data Layer

**Step 4.1 — Drift local database**

Create `lib/data/local/app_database.dart` with tables:
`NotesTable`, `TasksTable`, `CategoriesTable` — all fields from
Section 4.2, with `syncStatus` column.

Create DAOs: `NotesDao`, `TasksDao`, `CategoriesDao`.

Run `build_runner` again to generate Drift code.

## ⏸ APPROVAL CHECKPOINT 4.1

**Step 4.2 — Firestore data sources**

Create remote data sources in `lib/data/remote/`:
- `FirestoreNotesDatasource`
- `FirestoreTasksDatasource`
- `FirestoreCategoriesDatasource`

Each must implement stream-based watching (`watchX`) and
`Future`-based mutations (`save`, `delete`).

## ⏸ APPROVAL CHECKPOINT 4.2

**Step 4.3 — Repository layer + SyncService**

Create repositories in `lib/data/repositories/`:
- `NoteRepository`: offline-first — write Drift first, then Firestore.
- `TaskRepository`: same pattern.
- `CategoryRepository`: same pattern.
- `SyncService`: listens to `connectivity_plus`; on reconnect,
  flushes all `syncStatus = 'pending'` records to Firestore.

## ⏸ APPROVAL CHECKPOINT 4.3

**Step 4.4 — Deploy Firestore security rules**

Write `firestore.rules` from Section 8.
Write `firestore.indexes.json` with composite indexes.

```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## ⏸ APPROVAL CHECKPOINT 4.4

---

### PHASE 5 — Authentication

**Step 5.1 — Auth providers**

Create `lib/features/auth/auth_providers.dart`:
- `authStateProvider`: `StreamProvider<User?>`.
- `currentUserIdProvider`: `Provider<String?>`.
- `authControllerProvider`: `AsyncNotifierProvider` with
  `signInWithGoogle()` and `signOut()` methods.

## ⏸ APPROVAL CHECKPOINT 5.1

**Step 5.2 — Login screen**

Create `lib/features/auth/login_screen.dart`:

Visual spec:
- Full-bleed animated particle background using `CustomPainter`:
  40–60 floating dots connected by thin lines (neural network aesthetic).
  Dots drift slowly. Lines fade in/out as dots move in range.
  Uses `AnimationController` with `repeat()`.
- Centre column: app logo (Phosphor icon + text), tagline in
  `Rajdhani` italic, `NeonButton` with Google logo for Sign-In.
- On sign-in loading: button shows `CircularProgressIndicator`
  in neon color; particles pulse faster.
- On success: `GoRouter.go('/notes')`.
- Error: `SnackBar` with `kCrimson` background.

## ⏸ APPROVAL CHECKPOINT 5.2

---

### PHASE 6 — Categories Feature

**Step 6.1 — Category providers**

`lib/features/categories/category_providers.dart`:
- `categoriesProvider`: `StreamProvider<List<Category>>`.
- `categoryControllerProvider`: create, update, delete, reorder.

## ⏸ APPROVAL CHECKPOINT 6.1

**Step 6.2 — Category list screen**

`lib/features/categories/category_list_screen.dart`:
- GlassCard list of categories, each showing:
  - Category color swatch circle (8px dot).
  - Name in `DM Sans` 15pt.
  - Module badge chip (Notes / Tasks / Both).
  - Edit + delete action buttons (Phosphor icons, ghost style).
- `ReorderableListView` for drag-to-reorder.
- FAB with `+` icon to add new category.
- Empty state: Lottie animation + "Create your first category" text.

**Step 6.3 — Category form (modal bottom sheet)**

`lib/features/categories/category_form.dart`:
- GlassCard modal bottom sheet.
- Text field for name (styled, no default Material decoration).
- 16-swatch color grid + custom hex input field.
- Module selector: pill toggle row (Notes | Tasks | Both).
- Icon picker: 3-row scrollable grid of Phosphor icons.
- "Save" NeonButton + "Cancel" ghost button.

## ⏸ APPROVAL CHECKPOINT 6.2 / 6.3

---

### PHASE 7 — Notes Feature

**Step 7.1 — Note providers**

`lib/features/notes/note_providers.dart`:
- `notesStreamProvider`: `StreamProvider<List<Note>>`.
- `filteredNotesProvider`: applies search query + category filter + sort.
- `noteSearchQueryProvider`: `StateProvider<String>`.
- `selectedCategoryFilterProvider`: `StateProvider<String?>`.
- `sortOrderProvider`: `StateProvider<NoteSortOrder>`.

## ⏸ APPROVAL CHECKPOINT 7.1

**Step 7.2 — Note list screen**

`lib/features/notes/note_list_screen.dart`:

Visual spec:
- Header: animated search bar (expands on tap, contracts when empty).
  Right side: sort icon (Phosphor `SortAscending`), view toggle
  (grid/list — Phosphor `SquaresFour`/`Rows`).
- Category filter strip: horizontal scroll of `ColorFlagChip` widgets.
  "All" chip first. Selected chip brightens and gets a neon underline.
- Pinned section (if any): `GlassCard` section with pin icon header.
- Notes grid/list: `StaggeredList` animation on entry.
- `NoteCard`: GlassCard + left color strip + title + body preview +
  tags row + bottom meta row.
- Empty state: Lottie + text.
- FAB: `NeonButton` circular, `+` icon.

## ⏸ APPROVAL CHECKPOINT 7.2

**Step 7.3 — Note editor screen**

`lib/features/notes/note_editor_screen.dart`:

Visual spec:
- AppBar: back arrow (auto-saves on navigate), title "New Note" /
  note title truncated. Right actions: share, archive, delete (Phosphor).
- Title field: large `Rajdhani` 26pt, no border, placeholder "Untitled".
- `flutter_quill` editor: custom dark toolbar matching design tokens.
  Toolbar icons use Phosphor replacements where possible.
- Collapsible metadata panel (slide-down from top-right icon):
  - Category multi-select chips.
  - Tags field: comma-separated, shown as `ColorFlagChip` rows.
  - Context fields: expandable key-value list + "Add field" ghost button.
  - Pin toggle (Phosphor `PushPin`).
  - Timestamps (JetBrains Mono, `kTextMuted`).
- Links section: paste URL → "Fetch Preview" button →
  `LinkPreviewCard` inserted. Swipe-to-delete links.
- Attachments section: image thumbnails in horizontal scroll.
  Tap "+" → `image_picker` dialog.
- Auto-save: 500ms debounce after any change. Save indicator:
  tiny "Saving…" / "Saved ✓" text in `kTeal` at bottom.

## ⏸ APPROVAL CHECKPOINT 7.3

---

### PHASE 8 — Tasks & Calendar Feature

**Step 8.1 — Task providers**

`lib/features/tasks/task_providers.dart`:
- `tasksForDayProvider(DateTime)`: `StreamProvider`.
- `tasksInRangeProvider(DateTimeRange)`: `StreamProvider`.
- `overdueTasks Provider`: `StreamProvider`.
- `selectedDateProvider`: `StateProvider<DateTime>` (today).
- `calendarViewModeProvider`: `StateProvider<CalendarView>`.

## ⏸ APPROVAL CHECKPOINT 8.1

**Step 8.2 — Calendar screen**

`lib/features/tasks/calendar_screen.dart`:

Visual spec (Month view):
- `table_calendar` with fully custom `calendarBuilders`:
  - Today cell: pulsing neon ring animation (`AnimationController` repeat).
  - Normal cell: `kBg2` background, date text in `kTextPrimary`.
  - Selected cell: `kNeon` ring, `kGlassFill` background.
  - Days with tasks: row of max-3 colored micro-dots below date number.
  - Overdue days: date number in `kCrimson`.
- Header: `Rajdhani` 20pt month/year, prev/next arrows (Phosphor).
- View mode switcher: 3-pill toggle at top (`Day | Week | Month`).
- `TODAY` ghost button (top-right).

Visual spec (Week view):
- 7 `GlassCard` columns in a `Row`. Today column has `kGlowBlue` background.
- Column header: day abbreviation (Mon) + date number.
- Tasks shown as small `ColorFlagChip` pills inside column.
- Overflow indicator if > 3 tasks.

Visual spec (Day view):
- Time ruler: left column with hours 06:00 → 23:00 in `JetBrains Mono`.
- Current time indicator: animated horizontal neon line with pulsing dot.
- Task blocks: full-width gradient pills (`category color → transparent`).
- Empty slots: subtle dashed horizontal lines.

**Step 8.3 — Task list panel**

`lib/features/tasks/task_list_panel.dart`:
- `DraggableScrollableSheet` with `minChildSize: 0.15`, `maxChildSize: 0.85`.
- Handle bar at top (pill shape, `kBg3`).
- Date header in `Rajdhani` + task count badge.
- `TaskListItem`: left color bar (category), title, time chip
  (`JetBrains Mono`), priority dot, status toggle checkbox.
  Overdue items: `kCrimson` text + subtle red left bar.
- FAB inside panel: "Add task for this day".

## ⏸ APPROVAL CHECKPOINT 8.2 / 8.3

**Step 8.4 — Task editor screen**

`lib/features/tasks/task_editor_screen.dart`:

Visual spec:
- Same glass/dark aesthetic as note editor.
- Title field: `Rajdhani` 24pt.
- Date + Time row: two pill buttons (Phosphor `CalendarBlank`,
  `Clock`), tapping opens respective platform pickers.
- Priority selector: 5 horizontal pill buttons with color coding:
  None (grey) | Low (teal) | Medium (amber) | High (violet) | Critical (crimson).
- Status selector: horizontal scroll of status chips.
- Sub-tasks section: GlassCard with checklist items +
  animated progress bar in `kNeon`.
- Recurrence section: collapsible. Toggle switch with `Rajdhani` label.
  When on: RecurrencePickerWidget.
- Same links + context fields sections as Note editor.

**Step 8.5 — Recurrence picker widget**

`lib/features/tasks/recurrence_picker_widget.dart`:

Visual spec:
- Frequency row: horizontal pill selector
  (Daily | Weekly | Monthly | Quarterly | Half-Yearly | Annually | Custom).
  Selected pill glows in `kViolet`.
- Weekly sub-options: 7-day pill row (M T W T F S S),
  multi-selectable, selected = `kViolet` fill.
- Monthly sub-options: numeric day picker (1–31) in a `GridView`.
- Interval field: `kBg2` text input + "every N [unit]" label.
- End condition: 3-option radio row styled as pills:
  "No end" | "End by [date]" | "After [N] times".
- Live preview text: `"Repeats every Monday, Wednesday · ends Dec 31 2026"`
  in `JetBrains Mono kTextSecondary`.

## ⏸ APPROVAL CHECKPOINT 8.4 / 8.5

---

### PHASE 9 — Cloud Functions

**Step 9.1 — Initialise Cloud Functions**

```bash
cd noteflow_app
firebase init functions   # choose TypeScript, ESLint enabled
cd functions && npm install
```

Install additional packages:
```bash
npm install node-fetch cheerio
npm install --save-dev @types/node-fetch @types/cheerio
```

## ⏸ APPROVAL CHECKPOINT 9.1

**Step 9.2 — Implement all 5 Cloud Functions**

Implement all functions from Section 7 in `functions/src/index.ts`.

After implementation:
```bash
firebase deploy --only functions
```

Verify each function appears in Firebase console.

## ⏸ APPROVAL CHECKPOINT 9.2

---

### PHASE 10 — Notifications

**Step 10.1 — NotificationService**

`lib/core/notification_service.dart`:
- Android notification channel: `noteflow_tasks`.
- `scheduleTaskReminder(Task)`: uses `zonedSchedule` from
  `flutter_local_notifications`.
- `cancelTaskReminder(String taskId)`.
- `handleFCMMessage(RemoteMessage)`: show local notification.
- Request Android 13+ permission on app launch.

**Step 10.2 — FCMService**

`lib/core/fcm_service.dart`:
- Save FCM token to `/users/{uid}/fcmTokens/{tokenId}`.
- Foreground: `onMessage` → `NotificationService.show()`.
- Background tap: `onMessageOpenedApp` → navigate via GoRouter.

## ⏸ APPROVAL CHECKPOINT 10.1 / 10.2

---

### PHASE 11 — Settings Screen

**Step 11.1 — Settings screen**

`lib/features/settings/settings_screen.dart`:

Visual spec:
- Sections as `GlassCard` groups (not default `ListTile`):
  Profile | Appearance | Notifications | Security | Data | Account.
- Profile card: user avatar (cached network image with neon ring border),
  display name (`Rajdhani`), email (`JetBrains Mono kTextMuted`).
- Appearance: theme 3-pill toggle, accent color row (5 neon swatches),
  text size 4-pill row.
- Security: app lock toggle → triggers `local_auth` setup.
- Data: Export button → generates JSON ZIP to Downloads.
- Account: Sign Out (`NeonButton` ghost variant),
  Delete Account (`NeonButton` crimson variant with confirmation dialog).

## ⏸ APPROVAL CHECKPOINT 11.1

---

### PHASE 12 — Search

**Step 12.1 — Unified search screen**

`lib/features/search/search_screen.dart`:
- Full-screen overlay search (hero animation from search bar).
- Results grouped: Notes | Tasks.
- Match highlights: wrap matched substring in `kNeon` colored `TextSpan`.
- Filter row: All | Notes | Tasks | by Category.
- Recent searches: stored in SharedPreferences, shown as ghost chips.

## ⏸ APPROVAL CHECKPOINT 12.1

---

### PHASE 13 — Windows Desktop Adaptations

**Step 13.1 — 3-pane desktop layout**

Update `lib/core/responsive_layout.dart` for `> 1200px`:
- Left sidebar (200px): navigation rail + category list.
- Centre pane: note/task list.
- Right pane: note/task editor rendered inline (no push navigation).

**Step 13.2 — Keyboard shortcuts**

Using Flutter `Shortcuts` + `Actions` widgets:
- `Ctrl+N`: new note (on Notes tab) / new task (on Tasks tab).
- `Ctrl+F`: focus search overlay.
- `Ctrl+S`: save current editor.
- `Del`: delete selected item (with confirmation).
- `Ctrl+,`: open settings.
- `Esc`: close modal / deselect.

## ⏸ APPROVAL CHECKPOINT 13.1 / 13.2

---

### PHASE 14 — CI/CD, App Icon, Splash, Build

**Step 14.1 — App icon & splash**

- Create `assets/icon/app_icon.png`: hexagonal node-network mark in
  neon blue on black (1024×1024px). Use a placeholder if no design tool
  available; note where to replace it.
- Configure `flutter_launcher_icons` and `flutter_native_splash` in
  `pubspec.yaml` (already added in Section 6).
- Run:
  ```bash
  flutter pub run flutter_launcher_icons
  flutter pub run flutter_native_splash:create
  ```

## ⏸ APPROVAL CHECKPOINT 14.1

**Step 14.2 — GitHub Actions CI/CD**

Create `.github/workflows/ci.yml`:
- Jobs: `analyze`, `test`, `build-android`, `build-windows`.
- `build-android`: `flutter build apk --release --split-per-abi`.
  Upload APK artifacts.
- `build-windows`: `flutter build windows --release`.
  Upload MSIX artifact.
- Signing: keystore credentials injected from GitHub Secrets.

Create `android/key.properties.template` with placeholder values.
Update `android/app/build.gradle` to read `signingConfigs` from
`key.properties`.

## ⏸ APPROVAL CHECKPOINT 14.2

**Step 14.3 — Generate release APK**

```bash
flutter build apk --release --split-per-abi
```

Report APK path and size. Verify it is installable.

```bash
flutter build windows --release
```

Report EXE/MSIX path.

## ⏸ APPROVAL CHECKPOINT 14.3

---

### PHASE 15 — Integration Verification & Handover

**Step 15.1 — Full smoke test**

Run the following end-to-end flows and confirm each passes:

| # | Flow | Expected result |
|---|---|---|
| 1 | Sign in with Google | Lands on Notes screen |
| 2 | Create category (color + icon) | Appears in category list |
| 3 | Create note → assign category → add web link | Link preview renders |
| 4 | Edit note body → navigate away | Auto-saved, reopens with changes |
| 5 | Create task for today | Appears in Day view + Month view dot |
| 6 | Create weekly recurring task (Mon+Wed, 3-month end) | Instances generated for 30 days |
| 7 | Mark task done | Status updates across all views |
| 8 | Go offline → create note → go online | Note syncs to Firestore |
| 9 | Switch to Windows build | 3-pane layout renders |
| 10 | Open Settings → toggle dark/light theme | Theme switches immediately |

## ⏸ APPROVAL CHECKPOINT 15.1

**Step 15.2 — Final report**

Generate a markdown summary containing:
- ✅ Completed features checklist (from Section 3).
- ⚠️ Known limitations or deferred items.
- 📦 Build artifact paths (APK, EXE/MSIX).
- 🚀 Recommended next steps for v1.1.
- 💰 Estimated Firebase free-tier usage.

Present to human for final sign-off.

## ⏸ FINAL APPROVAL CHECKPOINT

---

## 10. Quick Reference — Key Commands

```bash
# Development
flutter run -d <device-id>          # Run on specific device
flutter devices                      # List connected devices
flutter emulators --launch <id>      # Launch Android emulator

# Code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Testing
flutter test
flutter analyze

# Build
flutter build apk --release --split-per-abi
flutter build windows --release

# Firebase
firebase deploy --only firestore:rules,firestore:indexes
firebase deploy --only functions
firebase emulators:start             # Local emulator for dev

# APK output location
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk

# Windows output location
# build/windows/x64/runner/Release/
```

---

## 11. Glossary

| Term | Meaning |
|---|---|
| GlassCard | Custom widget: BackdropFilter blur + semi-transparent fill + glow border |
| NeonButton | Custom CTA button with scale + glow animation on tap |
| Approval Checkpoint | A mandatory stop point where the agent presents a plan and waits for human "approved" before coding |
| Schema Freeze | No Firestore/Drift schema changes without a dedicated approval step |
| syncStatus | Drift column: `pending` (not yet synced to Firestore) / `synced` / `deleted` |
| Neural Glass | The design aesthetic: dark surfaces, glass morphism, neon accents, angular typography |
| Recurring Master | A Firestore document that defines the recurrence rule; Cloud Function generates individual task instances from it |
| StaggeredList | Custom widget that animates list items in sequentially with 50ms stagger delay |

---

*End of CLAUDE.md — Version 1.0 — NoteFlow & TaskCanvas*