import 'dart:convert';

import 'package:absensi_pkl/app.dart';
import 'package:absensi_pkl/core/constants/storage_keys.dart';
import 'package:absensi_pkl/core/services/camera_datasource.dart';
import 'package:absensi_pkl/core/services/location_datasource.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/core/testing/app_widget_keys.dart';
import 'package:absensi_pkl/features/attendance/data/datasources/demo_attendance_datasource.dart';
import 'package:absensi_pkl/features/attendance/domain/entities/location_reading.dart';
import 'package:absensi_pkl/features/attendance/repositories/attendance_repository_impl.dart';
import 'package:absensi_pkl/features/auth/data/datasources/demo_auth_datasource.dart';
import 'package:absensi_pkl/features/auth/data/models/auth_session_dto.dart';
import 'package:absensi_pkl/features/auth/data/models/dudi_placement_dto.dart';
import 'package:absensi_pkl/features/auth/data/models/student_profile_dto.dart';
import 'package:absensi_pkl/features/auth/repositories/auth_repository_impl.dart';
import 'package:absensi_pkl/features/journal/data/datasources/demo_journal_datasource.dart';
import 'package:absensi_pkl/features/journal/repositories/journal_repository_impl.dart';
import 'package:absensi_pkl/features/leave/data/datasources/demo_leave_datasource.dart';
import 'package:absensi_pkl/features/leave/repositories/leave_repository_impl.dart';
import 'package:absensi_pkl/features/settings/data/models/app_settings_dto.dart';
import 'package:absensi_pkl/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestLocationDatasource implements LocationDatasource {
  @override
  bool get isSimulationSupported => true;

  @override
  DemoLocationPreset get currentPreset => DemoLocationPreset.insideRadius;

  @override
  void setDemoPreset(DemoLocationPreset preset) {}

  @override
  Future<LocationReading> getCurrentLocation({
    required double targetLat,
    required double targetLng,
  }) async {
    return LocationReading(
      latitude: targetLat + 0.00030,
      longitude: targetLng + 0.00023,
      accuracyMeters: 8.5,
      isMocked: false,
      recordedAt: DateTime(2026, 4, 15, 7, 50),
    );
  }
}

class _TestCameraDatasource implements CameraDatasource {
  @override
  Future<CapturedSelfie?> captureSelfie() async {
    return CapturedSelfie(
      fileName: 'selfie_redesign_test.jpg',
      mimeType: 'image/jpeg',
      capturedAt: DateTime(2026, 4, 15, 7, 52),
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
    );
  }

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      captureSelfie();
}

Future<InMemorySecureStorageDatasource> _authenticatedStorage() async {
  final storage = InMemorySecureStorageDatasource();
  await storage.write(
    StorageKeys.appSettings,
    jsonEncode(const AppSettingsDto(onboardingSeen: true).toJson()),
  );
  final now = DateTime.now();
  final dto = AuthSessionDto(
    accessToken: 'test-token-redesign',
    issuedAtIso: now.subtract(const Duration(minutes: 5)).toIso8601String(),
    expiresAtIso: now.add(const Duration(days: 3)).toIso8601String(),
    student: const StudentProfileDto(
      id: 'std-2026-001',
      nisn: DemoAuthDatasource.demoNisn,
      fullName: 'Rafi Pratama Putra',
      className: 'XII RPL 2',
      major: 'Rekayasa Perangkat Lunak',
      email: DemoAuthDatasource.demoEmail,
      placement: DudiPlacementDto(
        id: 'dudi-001',
        companyName: 'PT Fanajalh Digital Indonesia',
        address: 'Jl. HR Rasuna Said Kav. 12',
        mentorName: 'Budi Santoso, S.Kom.',
        latitude: -6.208763,
        longitude: 106.845599,
        allowedRadiusMeters: 100.0,
        workStartTime: '08:00',
        workEndTime: '17:00',
      ),
    ),
  );
  await storage.write(StorageKeys.authSession, jsonEncode(dto.toJson()));
  return storage;
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets(
      'Onboarding -> Login -> Beranda -> Peta Lokasi -> Selfie flow works end-to-end without overflow at 375x812',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = InMemorySecureStorageDatasource();
    final container = ProviderContainer(
      overrides: [
        secureStorageDatasourceProvider.overrideWithValue(storage),
        authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        locationDatasourceProvider.overrideWithValue(_TestLocationDatasource()),
        cameraDatasourceProvider.overrideWithValue(_TestCameraDatasource()),
        attendanceDatasourceProvider.overrideWithValue(
          DemoAttendanceDatasource(clock: () => DateTime(2026, 4, 15, 7, 50)),
        ),
        journalDatasourceProvider.overrideWithValue(
          DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 7, 50)),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AbsensiPklApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Onboarding slides 1 -> 2 -> 3 -> Mulai
    expect(find.text('Absensi DUDI Akurat'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.onboardingNextButton));
    await tester.pumpAndSettle();
    expect(find.text('Selfie Kamera Langsung'), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.onboardingNextButton));
    await tester.pumpAndSettle();
    expect(find.text('Jurnal & Rekap'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.onboardingNextButton));
    await tester.pumpAndSettle();

    // 2. Redirected to Login -> Demo Fill -> Masuk -> Beranda
    expect(find.byKey(AppWidgetKeys.loginNisnField), findsOneWidget);
    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginDemoFillButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginDemoFillButton));
    await tester.pump();

    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Absensi PKL'), findsOneWidget);
    expect(find.text('Valid'), findsOneWidget);

    // Verify Announcements sheet opens from bell icon
    await tester.tap(find.byKey(AppWidgetKeys.announcementsButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Pengumuman'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 3. Beranda -> Peta Lokasi
    await tester.tap(find.byKey(AppWidgetKeys.mapShortcutButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lokasi Presensi'), findsOneWidget);
    expect(find.text('Dalam Area DUDI'), findsOneWidget);

    // 4. Peta Lokasi -> Selfie -> Submit Check-In -> Beranda
    await tester.tap(find.byKey(AppWidgetKeys.mapContinueSelfieButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Selfie'), findsOneWidget);
    expect(find.byKey(AppWidgetKeys.selfieShutterButton), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.selfieShutterButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Check-In berhasil dicatat.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets(
      'Profile -> Settings (Mode Gelap toggle), LeaveScreen (CupertinoSlidingSegmentedControl), and HistoryScreen render without overflow at 375x812',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await _authenticatedStorage();
    final fixedNow = DateTime(2026, 4, 15, 7, 50);
    final container = ProviderContainer(
      overrides: [
        secureStorageDatasourceProvider.overrideWithValue(storage),
        authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        locationDatasourceProvider.overrideWithValue(_TestLocationDatasource()),
        cameraDatasourceProvider.overrideWithValue(_TestCameraDatasource()),
        attendanceDatasourceProvider.overrideWithValue(
          DemoAttendanceDatasource(clock: () => fixedNow),
        ),
        journalDatasourceProvider.overrideWithValue(
          DemoJournalDatasource(clock: () => fixedNow),
        ),
        leaveDatasourceProvider.overrideWithValue(
          DemoLeaveDatasource(clock: () => fixedNow),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AbsensiPklApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // 1. Beranda -> Profile -> Settings -> Toggle Mode Gelap
    await tester.tap(find.byKey(AppWidgetKeys.profileAvatarButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Profil Siswa'), findsOneWidget);
    expect(find.text('Rafi Pratama Putra'), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.settingsButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Pengaturan'), findsWidgets);
    expect(find.text('Mode Gelap'), findsOneWidget);

    await tester.tap(find.byKey(AppWidgetKeys.settingsDarkModeSwitch));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(container.read(settingsProvider).requireValue.isDarkMode, isTrue);

    // Pop Settings -> Profile -> Beranda
    await tester.tap(find.text('Profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Beranda').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 2. Navigate to Izin tab (LeaveScreen with CupertinoSlidingSegmentedControl)
    await tester.tap(find.byKey(AppWidgetKeys.navTabIzin));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Izin & Sakit'), findsOneWidget);
    expect(find.byKey(AppWidgetKeys.leaveTypeSegment), findsOneWidget);

    await tester.tap(find.text('Izin Resmi'));
    await tester.pump();

    // Short reason validation feedback
    await tester.enterText(
      find.byKey(AppWidgetKeys.leaveReasonField),
      'Izin',
    );
    await tester.tap(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.pump();
    expect(find.text('Keterangan minimal 10 karakter.'), findsOneWidget);

    // Valid reason submission
    await tester.enterText(
      find.byKey(AppWidgetKeys.leaveReasonField),
      'Mengikuti lomba kompetensi siswa tingkat kota.',
    );
    await tester.tap(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.text('Pengajuan berhasil dikirim ke pembimbing.'),
      findsOneWidget,
    );

    // 3. Navigate to Riwayat tab (HistoryScreen) and switch Cupertino filters
    await tester.tap(find.byKey(AppWidgetKeys.navTabRiwayat));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Riwayat'), findsWidgets);
    expect(find.text('Tingkat Hadir'), findsOneWidget);
    expect(find.text('Hari Masuk'), findsOneWidget);
    expect(find.byKey(AppWidgetKeys.historyFilterSegment), findsOneWidget);

    final segmentFinder = find.byKey(AppWidgetKeys.historyFilterSegment);
    await tester.tap(
      find.descendant(of: segmentFinder, matching: find.text('Hadir')),
    );
    await tester.pump();
    await tester.tap(
      find.descendant(of: segmentFinder, matching: find.text('Telat')),
    );
    await tester.pump();
    await tester.tap(
      find.descendant(of: segmentFinder, matching: find.text('Izin')),
    );
    await tester.pump();
    await tester.tap(
      find.descendant(of: segmentFinder, matching: find.text('Semua')),
    );
    await tester.pump();

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
