import 'dart:typed_data';

import 'package:absensi_pkl/core/constants/api_paths.dart';
import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/core/services/camera_datasource.dart';
import 'package:absensi_pkl/core/services/location_datasource.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/features/attendance/data/datasources/demo_attendance_datasource.dart';
import 'package:absensi_pkl/features/attendance/domain/entities/location_reading.dart';
import 'package:absensi_pkl/features/attendance/presentation/notifiers/attendance_notifier.dart';
import 'package:absensi_pkl/features/attendance/repositories/attendance_repository_impl.dart';
import 'package:absensi_pkl/features/auth/data/datasources/demo_auth_datasource.dart';
import 'package:absensi_pkl/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:absensi_pkl/features/auth/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocationDatasource implements LocationDatasource {
  _FakeLocationDatasource({DemoLocationPreset initial = DemoLocationPreset.insideRadius})
      : _preset = initial;

  DemoLocationPreset _preset;

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
          accuracyMeters: 8.0,
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
          latitude: targetLat + 0.00020,
          longitude: targetLng + 0.00020,
          accuracyMeters: 5.0,
          isMocked: true,
          recordedAt: now,
        ),
    };
  }
}

class _FakeCameraDatasource implements CameraDatasource {
  int callCount = 0;

  @override
  Future<CapturedSelfie?> captureSelfie() async {
    callCount++;
    return CapturedSelfie(
      fileName: 'selfie_test_$callCount.jpg',
      mimeType: 'image/jpeg',
      capturedAt: DateTime(2026, 4, 15, 7, 51),
      bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
    );
  }

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      captureSelfie();
}

Future<ProviderContainer> _createAuthenticatedContainer({
  required _FakeLocationDatasource locationDatasource,
  required _FakeCameraDatasource cameraDatasource,
  required DateTime fixedNow,
}) async {
  final storage = InMemorySecureStorageDatasource();
  final container = ProviderContainer.test(
    overrides: [
      secureStorageDatasourceProvider.overrideWithValue(storage),
      authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
      locationDatasourceProvider.overrideWithValue(locationDatasource),
      cameraDatasourceProvider.overrideWithValue(cameraDatasource),
      attendanceDatasourceProvider.overrideWithValue(
        DemoAttendanceDatasource(clock: () => fixedNow),
      ),
    ],
  );

  await container.read(authProvider.notifier).login(
        identifier: DemoAuthDatasource.demoNisn,
        password: DemoAuthDatasource.demoPasscode,
      );
  return container;
}

void main() {
  group('AttendanceNotifier', () {
    test('allows check-in within radius and transitions to checked-in state',
        () async {
      final location = _FakeLocationDatasource();
      final camera = _FakeCameraDatasource();
      final container = await _createAuthenticatedContainer(
        locationDatasource: location,
        cameraDatasource: camera,
        fixedNow: DateTime(2026, 4, 15, 7, 52),
      );

      final initialState = await container.read(attendanceProvider.future);
      expect(initialState.todayRecord, isNull);
      expect(initialState.geofence?.isWithinRadius, isTrue);
      expect(initialState.geofence?.isMocked, isFalse);

      final prepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();

      expect(prepared, isNotNull);
      expect(camera.callCount, equals(1));
      expect(prepared!.geofence.canSubmitAttendance, isTrue);

      final submitted =
          await container.read(attendanceProvider.notifier).submitAttendance(
                selfie: prepared.selfie,
                geofence: prepared.geofence,
              );

      expect(submitted, isTrue);
      final updated = container.read(attendanceProvider).requireValue;
      expect(updated.todayRecord?.hasCheckedIn, isTrue);
      expect(updated.todayRecord?.hasCheckedOut, isFalse);
      expect(updated.actionSuccessMessage, equals('Check-In berhasil dicatat.'));
      expect(updated.actionError, isNull);
    });

    test('blocks check-in when isMocked == true without opening camera',
        () async {
      final location =
          _FakeLocationDatasource(initial: DemoLocationPreset.mockGps);
      final camera = _FakeCameraDatasource();
      final container = await _createAuthenticatedContainer(
        locationDatasource: location,
        cameraDatasource: camera,
        fixedNow: DateTime(2026, 4, 15, 7, 52),
      );

      await container.read(attendanceProvider.future);

      final prepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();

      expect(prepared, isNull);
      expect(camera.callCount, equals(0));
      final state = container.read(attendanceProvider).requireValue;
      expect(state.actionError, isA<MockLocationDetectedError>());
      expect(state.todayRecord, isNull);

      await expectLater(
        () => container.read(attendanceRepositoryProvider).submitCheckIn(
              location: LocationReading(
                latitude: ApiPaths.defaultDudiLatitude,
                longitude: ApiPaths.defaultDudiLongitude,
                accuracyMeters: 5.0,
                isMocked: true,
                recordedAt: DateTime(2026, 4, 15, 7, 52),
              ),
              distanceMeters: 10.0,
              allowedRadiusMeters: 100.0,
              selfieLabel: 'spoof.jpg',
              workStartTime: '08:00',
            ),
        throwsA(isA<MockLocationDetectedError>()),
      );
    });

    test('blocks check-in when outside radius without opening camera',
        () async {
      final location =
          _FakeLocationDatasource(initial: DemoLocationPreset.outsideRadius);
      final camera = _FakeCameraDatasource();
      final container = await _createAuthenticatedContainer(
        locationDatasource: location,
        cameraDatasource: camera,
        fixedNow: DateTime(2026, 4, 15, 7, 52),
      );

      await container.read(attendanceProvider.future);

      final prepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();

      expect(prepared, isNull);
      expect(camera.callCount, equals(0));
      final state = container.read(attendanceProvider).requireValue;
      expect(state.actionError, isA<OutOfGeofenceError>());
      expect(state.geofence?.isWithinRadius, isFalse);
      expect(state.todayRecord, isNull);

      await expectLater(
        () => container.read(attendanceRepositoryProvider).submitCheckIn(
              location: LocationReading(
                latitude: ApiPaths.defaultDudiLatitude + 0.0024,
                longitude: ApiPaths.defaultDudiLongitude + 0.0016,
                accuracyMeters: 10.0,
                isMocked: false,
                recordedAt: DateTime(2026, 4, 15, 7, 52),
              ),
              distanceMeters: 320.0,
              allowedRadiusMeters: 100.0,
              selfieLabel: 'far.jpg',
              workStartTime: '08:00',
            ),
        throwsA(isA<OutOfGeofenceError>()),
      );
    });

    test('transitions from check-in to check-out cleanly', () async {
      final location = _FakeLocationDatasource();
      final camera = _FakeCameraDatasource();
      final container = await _createAuthenticatedContainer(
        locationDatasource: location,
        cameraDatasource: camera,
        fixedNow: DateTime(2026, 4, 15, 7, 55),
      );

      await container.read(attendanceProvider.future);

      final checkInPrepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();
      await container.read(attendanceProvider.notifier).submitAttendance(
            selfie: checkInPrepared!.selfie,
            geofence: checkInPrepared.geofence,
          );

      final checkOutPrepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();
      final checkedOut =
          await container.read(attendanceProvider.notifier).submitAttendance(
                selfie: checkOutPrepared!.selfie,
                geofence: checkOutPrepared.geofence,
              );

      expect(checkedOut, isTrue);
      final finalState = container.read(attendanceProvider).requireValue;
      expect(finalState.todayRecord?.hasCheckedIn, isTrue);
      expect(finalState.todayRecord?.hasCheckedOut, isTrue);
      expect(
        finalState.actionSuccessMessage,
        equals('Check-Out berhasil dicatat.'),
      );
    });

    test('guards against duplicate check-in on the same day', () async {
      final location = _FakeLocationDatasource();
      final camera = _FakeCameraDatasource();
      final container = await _createAuthenticatedContainer(
        locationDatasource: location,
        cameraDatasource: camera,
        fixedNow: DateTime(2026, 4, 15, 7, 55),
      );

      await container.read(attendanceProvider.future);

      final prepared = await container
          .read(attendanceProvider.notifier)
          .prepareAttendanceSelfie();
      await container.read(attendanceProvider.notifier).submitAttendance(
            selfie: prepared!.selfie,
            geofence: prepared.geofence,
          );

      await expectLater(
        () => container.read(attendanceRepositoryProvider).submitCheckIn(
              location: prepared.geofence.location,
              distanceMeters: prepared.geofence.distanceMeters,
              allowedRadiusMeters: 100.0,
              selfieLabel: 'duplicate.jpg',
              workStartTime: '08:00',
            ),
        throwsA(
          isA<ValidationError>().having(
            (e) => e.message,
            'message',
            'Anda sudah melakukan check-in hari ini.',
          ),
        ),
      );
    });
  });
}
