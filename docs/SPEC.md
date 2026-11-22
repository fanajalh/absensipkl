# Technical Specification: Absensi Digital Siswa PKL

**Project:** `absensi_pkl` (PT fanajalh.id)  
**Target SDK:** Flutter `3.41.6` (stable) · Dart `^3.11.4`  
**Architecture:** Feature-First Clean Architecture + Riverpod Codegen + Typed GoRouter  
**Design System:** Apple iOS Minimal-Shadow HIG + Pastel Bento Dashboard  

---

## 1. Product Scope

### 1.1 MVP Scope (In-Scope)
1. **Onboarding & Siswa PKL Authentication**
   - 3-step swipeable student onboarding (`/onboarding`) persisted via `onboarding_seen` flag in `SettingsDatasource`.
   - Login (`/login`) with NISN/Email & Password, persisted session in `SecureStorageDatasource`, typed `GoRouter` redirect guard, and clean Logout.
   - Pre-seeded demo student & DUDI placement for immediate Web/Test evaluation.
2. **Beranda (Presensi Dashboard), Geofence Map & iOS Selfie Camera**
   - Pastel bento **Beranda** (`/`): Student avatar (`-> /profile`), map pin shortcut (`-> /attendance/map`), Lavender `Presensi harian` card with live tabular clock (`HH:mm:ss WIB`) & geofence status/distance pill, 7-day calendar strip, and `Agenda PKL` bento grid (`Check-In DUDI` Amber card, `Jurnal PKL` Sky Blue card, Pink quick-action dock).
   - **Peta Lokasi (`/attendance/map`):** Apple Maps-style `CustomPainter` geofence map showing `100 m` dashed DUDI circle, live student dot, `GPS Asli` & `Akurasi` chips, coordinates sheet, and `Lanjut Selfie Check-In` CTA.
   - **Kamera Selfie (`/attendance/selfie`):** iOS Camera UI (`#000000` canvas, `#FFD60A` `Batal` & oval face guide, live distance/clock tags, shutter capturing via `CameraDatasource` + confirmation/submit).
   - **Haversine + Anti-Fake-GPS:** Rejects `isMocked == true` and `distanceMeters > allowedRadiusMeters` client-side as immediate UX guard and logs integrity telemetry.
3. **Jurnal Kegiatan PKL (`/jurnal`)**
   - Large Title `Jurnal PKL` with `+ Tambah`, pastel status-coded cards (`Menunggu` Sky Blue, `Disetujui` White, `Revisi` Amber), and create/edit form (`/jurnal/form`).
4. **Pengajuan Izin / Sakit (`/izin`)**
   - Unified iOS view with Large Title `Izin & Sakit`, `CupertinoSlidingSegmentedControl` (`Sakit` / `Izin Resmi`), inset-grouped date/reason/attachment form, `Kirim` action, and `Riwayat pengajuan` list.
5. **Riwayat & Rekap Kehadiran (`/riwayat`)**
   - Large Title `Riwayat`, 2 pastel KPI bento tiles (`Tingkat Hadir %` Lavender, `Hari Masuk` Amber), `CupertinoSlidingSegmentedControl` (`Semua`, `Hadir`, `Telat`, `Izin`), and a single inset-grouped list with `0.5px` hairline dividers + detail sheet.
6. **Profil Siswa (`/profile`) & Pengaturan (`/settings`)**
   - **Profil:** Student identity Lavender card, DUDI placement Amber card, `Perangkat terikat (Device ID)` status, `Pengaturan aplikasi` link, and `Keluar dari Akun`.
   - **Pengaturan:** iOS inset-grouped list with working `Switch.adaptive` (`Pengingat Check-In (07:45)`, `Pengingat Jurnal (16:30)`, **Mode Gelap** wired to app `ThemeMode` provider), GPS/Camera/Anti-Fake-GPS status rows, and `Simulasi QA & Web` geofence preset trigger.
7. **Pluggable Data & Platform Abstraction**
   - Storage, GPS, camera, settings, and backend datasources sit behind `abstract interface class` contracts so REST/Supabase swaps require zero `domain/` or `presentation/` edits.

### 1.2 Out-of-Scope (Post-MVP)
- Multi-role portals (Guru Pembimbing / Pembimbing DUDI approval UI & Admin web dashboard).
- Live REST/Supabase backend, offline SQLite sync queue, and local OS push notification scheduling (switches persist user preference cleanly for future notification hookup).
- Dynamic QR code DUDI check-in, PDF/Excel export, ML face recognition/liveness detection.

---

## 2. User Flows & Typed Routing

### 2.1 Pure Redirect Guard (`redirect_resolver.dart`)
`resolveAppRedirect(...)` evaluates state in strict order:
1. If auth or settings state is still loading → return `null` (stay until hydrated).
2. If `!hasSeenOnboarding` → `/onboarding` (unless already on `/onboarding`).
3. Else if `!isAuthenticated` → `/login` (unless already on `/login`).
4. Else if currently on `/login` or `/onboarding` → `/` (`PresensiRoute`).

### 2.2 Route Tree (`app_routes.dart`)
- **Standalone / Flow Routes:**
  - `/onboarding` (`OnboardingRoute`)
  - `/login` (`LoginRoute`)
  - `/attendance/map` (`AttendanceMapRoute`)
  - `/attendance/selfie` (`AttendanceSelfieRoute`)
  - `/profile` (`ProfileRoute`)
  - `/settings` (`SettingsRoute`)
- **4-Tab Shell (`StatefulShellRoute.indexedStack`, translucent iOS tab bar):**
  1. `/` (`PresensiRoute`) — **Beranda**
  2. `/jurnal` (`JurnalRoute`) + child `/jurnal/form` (`JournalFormRoute`) — **Jurnal**
  3. `/izin` (`IzinRoute`) — **Izin**
  4. `/riwayat` (`RiwayatRoute`) — **Riwayat**

---

## 3. Modular Feature-First Directory Layout

Strict downward dependency rule: `presentation -> domain <- repositories -> data`.

```text
lib/
├── main.dart
├── app.dart                         # Watches SettingsNotifier.isDarkMode -> ThemeMode
├── core/
│   ├── constants/                   # ApiPaths, StorageKeys (incl. onboarding & settings keys)
│   ├── errors/                      # Freezed sealed AppError + Indonesian user messages
│   ├── extensions/                  # DateTime WIB/local formatting helpers via intl
│   ├── router/                      # @riverpod GoRouter, typed GoRouteData, pure redirect_resolver
│   ├── services/                    # CameraDatasource, LocationDatasource, SecureStorageDatasource, haversine
│   ├── testing/                     # AppWidgetKeys central ValueKey registry
│   └── theme/                       # iOS minimal-shadow palette, 0.5px hairline tokens, Light & Dark ThemeData
└── features/
    ├── onboarding/
    │   └── presentation/            # OnboardingScreen (3-step PageView) + pure slide widgets
    ├── auth/                        # LoginScreen (Lavender hero + inset form + Amber demo card)
    ├── attendance/                  # AttendanceHomeScreen (pastel bento), AttendanceMapScreen (CustomPainter),
    │                                # AttendanceSelfieScreen (iOS Camera UI), LiveClockNotifier, AttendanceNotifier
    ├── journal/                     # JournalListScreen, JournalFormScreen, JournalNotifier
    ├── leave/                       # LeaveScreen (unified segment + inset form + history), LeaveNotifier
    ├── history/                     # HistoryScreen (2 KPI bento tiles + segment + single grouped list), HistoryNotifier
    └── settings/
        ├── data/                    # SettingsDatasource + SecureSettingsDatasource + SettingsDto
        ├── domain/                  # AppSettings (pure Dart Freezed: onboardingSeen, reminders, isDarkMode)
        ├── repositories/            # SettingsRepositoryImpl
        └── presentation/            # SettingsNotifier (@Riverpod(keepAlive: true)), ProfileScreen, SettingsScreen
```

### Hard Architecture Rules
- **Pure `domain/`:** Zero imports from `package:flutter/*` (do **not** import `ThemeMode` into `domain/`—keep `isDarkMode: bool` in `AppSettings` and map to `ThemeMode` in `app.dart`), `json_annotation`, `flutter_secure_storage`, `geolocator`, `image_picker`, or `dart:io`.
- **Models != Entities:** `fromJson`/`toJson` stay strictly in `data/models/`.
- **Plugin Isolation:** `flutter_secure_storage`, `geolocator`, `image_picker`, and `dart:io` are allowed **only** in `core/services/*_datasource.dart` or `data/datasources/`.
- **Web & Test Portability:** `kIsWeb` / test overrides ensure `flutter test` and `flutter run -d chrome` work seamlessly without missing-plugin crashes. `GeofenceDemoSheet` remains accessible from Settings (`Simulasi QA & Web`) and Attendance debug/demo controls.
- **Dumb Widgets:** `presentation/widgets/` accept immutable props and typed callbacks only (no `WidgetRef`, `Notifier`, `Repository`, or `GoRouter` imports). Zero `_buildXxx()` widget helper methods; extract public `StatelessWidget`/`ConsumerWidget` classes.
- **Riverpod 3.x Codegen & Guards:** Use `@riverpod` / `@Riverpod(keepAlive: true)` with `Ref`, `if (!ref.mounted) return;` after every `await`, `if (!context.mounted) return;` in UI callbacks, `AsyncValue.guard` on refresh/filter mutations, `ref.onDispose(...)` for timers/listeners, and `ref.watch(...select(...))` to isolate clock ticks.

---

## 4. Verified Compatible Dependencies

Verified on **Dart `3.11.4` / Flutter `3.41.6`**:
- Runtime: `flutter_riverpod: ^3.3.1`, `riverpod_annotation: ^4.0.2`, `freezed_annotation: ^3.1.0`, `json_annotation: ^4.11.0`, `go_router: ^17.5.0`, `flutter_secure_storage: ^11.2.0`, `geolocator: ^14.1.2`, `image_picker: ^1.2.4`, `intl: ^0.20.3`, `cupertino_icons: ^1.0.8`.
- Dev: `flutter_lints: ^6.0.0`, `build_runner: ^2.15.1`, `riverpod_generator: ^4.0.3`, `freezed: ^3.2.5`, `json_serializable: ^6.13.0`, `go_router_builder: ^4.5.0`, `riverpod_lint: ^3.1.3`.

---

## 5. Approved iOS Minimal-Shadow Design System & Anti-AI-Slop Rules

1. **Palette & Surfaces:**
   - **Light Mode:** Grouped Canvas `#F2F2F7`, Surface `#FFFFFF`, Hairline Divider `Color.fromRGBO(60, 60, 67, 0.14)` (`0.5px` / `1px`), iOS Primary `#007AFF`, Active Switch `#34C759`, Primary Text `#1C1C1E`, Muted Text `#6E6E73`.
   - **Dark Mode:** Grouped Canvas `#000000`, Elevated Surface `#1C1C1E`, Secondary Surface `#2C2C2E`, Hairline Divider `Color.fromRGBO(255, 255, 255, 0.14)`, iOS Blue `#0A84FF`, Primary Text `#F2F2F7`, Muted Text `#AEAEB2`.
   - **Pastel Bento Palette (Beranda, Profil, Riwayat KPIs, Jurnal):** Lavender `#BEB0FA`, Amber `#FFCB6B`, Sky Blue `#B8D7FC`, Pink `#F8B4EB`. On pastel surfaces, tint secondary text from that surface's foreground hue (never muddy neutral gray) and ensure `>= 4.5:1` contrast (use darker rich surface equivalents in dark mode).
   - **Camera UI (`/attendance/selfie`):** Canvas `#000000`, Accent `#FFD60A` (`Batal`, oval face guide, flash icon), dark pill overlays.
   - **Minimal-Shadow Discipline:** Avoid `BoxShadow` / elevation across cards and sheets; rely on canvas-vs-surface contrast, pastel fills, and `0.5px` hairline dividers.
2. **Strict Anti-AI-Slop Rules:**
   - **No Generic Card Soup / Nested Cards:** Group form inputs, settings rows, and history rows inside **one** rounded white surface separated by `0.5px` hairline dividers—never cards inside cards.
   - **No ALL-CAPS Eyebrows / Kickers:** Never render tracked uppercase kickers above headings.
   - **No Middle-Dot Meta Strings (`A · B · C`):** Never concatenate unrelated metadata with `·` or `•` strings; separate distinct attributes by line, column, or weight.
   - **No Emoji Icons:** Use consistent stroke/Cupertino/Material icons only.
   - **No Neon Glows or Mesh Noise:** Zero glowing blurs or grid backdrops.
   - **Cognitive Load Ceiling:** Keep `<= 4` items per decision group; crisp action-oriented Indonesian copy.
3. **Apple iOS HIG Ergonomics:**
   - **Controls:** `CupertinoSlidingSegmentedControl`, `Switch.adaptive`, `CircularProgressIndicator.adaptive`, `AlertDialog.adaptive`, translucent bottom navigation bar (`Beranda`, `Jurnal`, `Izin`, `Riwayat`), Large Titles.
   - **Typography & Numbers:** `FontFeature.tabularFigures()` on live clocks, distances, dates, and KPI counters.
   - **Layout & Touch:** `375pt` mobile-first, `ConstrainedBox(maxWidth: 680)` on wide viewports, `SafeArea` + `MediaQuery.paddingOf(context).bottom` padding on scrollables, `44x48pt` minimum hit targets, `HitTestBehavior.opaque`, `ScrollViewKeyboardDismissBehavior.onDrag`, `HapticFeedback.lightImpact()` / `mediumImpact()`.

---

## 6. Security (OWASP MASVS + Top 10:2025) & Acceptance Criteria

- **Security:** Session tokens & settings stored via `FlutterSecureStorage` inside datasources; zero embedded API secrets; `android:allowBackup="false"` + GPS/Camera permissions in `AndroidManifest.xml` and `Info.plist`; `isMocked`, Haversine, and camera-only checks act as client signals with server verification assumed when REST/Supabase is attached; typed `AppError` handling with zero raw exceptions shown to users.
- **Acceptance Criteria:**
  1. `dart run build_runner build --delete-conflicting-outputs` exits `0`.
  2. `dart analyze --fatal-infos` exits `0` (zero `TODO`s, zero `_buildXxx()`, zero boundary violations).
  3. `flutter test --test-randomize-ordering-seed random` passes covering domain logic, `SettingsNotifier` (`onboarding_seen` + `isDarkMode`), `resolveAppRedirect`, `AttendanceNotifier`, `JournalNotifier`, `LeaveNotifier`, `HistoryNotifier`, and widget tests across the new flows at `375x812pt` with zero overflows.
  4. `flutter build web` exits `0` and all 9 screens render cleanly in Chrome Web.
