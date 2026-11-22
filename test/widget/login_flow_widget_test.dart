import 'dart:convert';
import 'dart:typed_data';

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
import 'package:absensi_pkl/features/auth/repositories/auth_repository_impl.dart';
import 'package:absensi_pkl/features/journal/data/datasources/demo_journal_datasource.dart';
import 'package:absensi_pkl/features/journal/repositories/journal_repository_impl.dart';
import 'package:absensi_pkl/features/settings/data/models/app_settings_dto.dart';
import 'package:flutter/material.dart';
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
      fileName: 'selfie_login_flow.jpg',
      mimeType: 'image/jpeg',
      capturedAt: DateTime(2026, 4, 15, 7, 50),
      bytes: Uint8List.fromList(<int>[1, 2, 3]),
    );
  }

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      captureSelfie();
}

void main() {
  testWidgets(
      'Login flow validates inputs, rejects invalid password, and navigates to Beranda on demo login at 375pt width',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = InMemorySecureStorageDatasource();
    await storage.write(
      StorageKeys.appSettings,
      jsonEncode(const AppSettingsDto(onboardingSeen: true).toJson()),
    );

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

    expect(find.byKey(AppWidgetKeys.loginNisnField), findsOneWidget);

    // 1. Empty submission triggers form validators
    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.pumpAndSettle();

    expect(find.text('NISN / Email wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);

    // 2. Invalid credentials show error banner
    await tester.enterText(
      find.byKey(AppWidgetKeys.loginNisnField),
      '0078451920',
    );
    await tester.enterText(
      find.byKey(AppWidgetKeys.loginPasswordField),
      'salah123',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.pumpAndSettle();

    expect(
      find.text('NISN/Email atau kata sandi tidak sesuai.'),
      findsOneWidget,
    );

    // 3. One-tap demo fill + submit navigates to Beranda
    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginDemoFillButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginDemoFillButton));
    await tester.pump();

    await tester.ensureVisible(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.loginSubmitButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Absensi PKL'), findsOneWidget);
    expect(find.text('Rekap Mingguan'), findsOneWidget);
    expect(find.text('PT Fanajalh Digital Indonesia'), findsWidgets);
    expect(find.byKey(AppWidgetKeys.liveClockText), findsOneWidget);

    // Dispose widget tree & container cleanly so LiveClockNotifier timer cancels
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
