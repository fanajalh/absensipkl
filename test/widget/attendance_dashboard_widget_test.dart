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
import 'package:absensi_pkl/features/settings/data/models/app_settings_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestLocationDatasource implements LocationDatasource {
  DemoLocationPreset _preset = DemoLocationPreset.insideRadius;

  @override
  bool get isSimulationSupported => true;

  @override
  DemoLocationPreset get currentPreset => _preset;

  @override
  void setDemoPreset(DemoLocationPreset preset) {
    _preset = preset;
  }

  @override
  Future<LocationReading> getCurrentLocation({
    required double targetLat,
    required double targetLng,
  }) async {
    final now = DateTime(2026, 4, 15, 7, 50);
    return switch (_preset) {
      DemoLocationPreset.insideRadius => LocationReading(
          latitude: targetLat + 0.00030,
          longitude: targetLng + 0.00023,
          accuracyMeters: 8.5,
          isMocked: false,
          recordedAt: now,
        ),
      DemoLocationPreset.outsideRadius => LocationReading(
          latitude: targetLat + 0.00240,
          longitude: targetLng + 0.00160,
          accuracyMeters: 12.0,
          isMocked: false,
          recordedAt: now,
        ),
      DemoLocationPreset.mockGps => LocationReading(
          latitude: targetLat + 0.00025,
          longitude: targetLng + 0.00020,
          accuracyMeters: 5.0,
          isMocked: true,
          recordedAt: now,
        ),
    };
  }
}

class _TestCameraDatasource implements CameraDatasource {
  @override
  Future<CapturedSelfie?> captureSelfie() async {
    return CapturedSelfie(
      fileName: 'selfie_widget_test.jpg',
      mimeType: 'image/jpeg',
      capturedAt: DateTime(2026, 4, 15, 7, 52),
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
    );
  }

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      captureSelfie();
}

Future<InMemorySecureStorageDatasource> _seededStorage() async {
  final storage = InMemorySecureStorageDatasource();
  await storage.write(
    StorageKeys.appSettings,
    jsonEncode(const AppSettingsDto(onboardingSeen: true).toJson()),
  );
  final now = DateTime.now();
  final dto = AuthSessionDto(
    accessToken: 'test-token-123',
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
      'Beranda -> Map -> Selfie flow displays live clock, guards mock GPS & outside radius, and completes check-in at 375x812',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await _seededStorage();
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    // Verify Beranda live clock + inside radius pill
    final clockFinder = find.byKey(AppWidgetKeys.liveClockText);
    expect(clockFinder, findsOneWidget);
    final clockText = tester.widget<Text>(clockFinder).data;
    expect(clockText, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
    expect(find.text('WIB'), findsOneWidget);
    expect(find.text('Valid'), findsOneWidget);

    // Open Peta Lokasi via top map shortcut
    await tester.tap(find.byKey(AppWidgetKeys.mapShortcutButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Lokasi Presensi'), findsOneWidget);

    // Switch DemoLocationPreset to Mock GPS -> blocked when tapping continue
    await tester.tap(find.byKey(AppWidgetKeys.geofenceTestSheetButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(AppWidgetKeys.geofencePresetMock));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Mock GPS Terdeteksi'), findsOneWidget);
    await tester.tap(find.byKey(AppWidgetKeys.mapContinueSelfieButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.textContaining('Lokasi palsu (Fake GPS) terdeteksi'),
      findsOneWidget,
    );
    expect(find.byKey(AppWidgetKeys.selfieShutterButton), findsNothing);

    // Switch DemoLocationPreset to Outside Radius -> blocked when tapping continue
    await tester.tap(find.byKey(AppWidgetKeys.geofenceTestSheetButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(AppWidgetKeys.geofencePresetOutside));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Di Luar Area DUDI'), findsOneWidget);
    await tester.tap(find.byKey(AppWidgetKeys.mapContinueSelfieButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Anda berada di luar radius DUDI'), findsOneWidget);
    expect(find.byKey(AppWidgetKeys.selfieShutterButton), findsNothing);

    // Switch back to Inside Radius -> continue to Selfie Camera & submit
    await tester.tap(find.byKey(AppWidgetKeys.geofenceTestSheetButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(AppWidgetKeys.geofencePresetInside));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dalam Area DUDI'), findsOneWidget);
    await tester.tap(find.byKey(AppWidgetKeys.mapContinueSelfieButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(AppWidgetKeys.selfieShutterButton), findsOneWidget);
    await tester.tap(find.byKey(AppWidgetKeys.selfieShutterButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Returned cleanly from Selfie to Map -> pop back to Beranda
    expect(find.text('Check-In berhasil dicatat.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
