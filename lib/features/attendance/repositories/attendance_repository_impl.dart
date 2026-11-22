import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/haversine.dart';
import '../../../core/services/location_datasource.dart';
import '../data/datasources/attendance_datasource.dart';
import '../data/datasources/demo_attendance_datasource.dart';
import '../data/datasources/remote_attendance_datasource.dart';
import '../data/models/check_in_payload_dto.dart';
import '../domain/entities/attendance_record.dart';
import '../domain/entities/geofence_evaluation.dart';
import '../domain/entities/location_reading.dart';
import '../domain/entities/siswa_home_snapshot.dart';
import '../domain/repositories/attendance_repository.dart';

part 'attendance_repository_impl.g.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl({
    required AttendanceDatasource datasource,
    required LocationDatasource locationDatasource,
  })  : _datasource = datasource,
        _locationDatasource = locationDatasource;

  final AttendanceDatasource _datasource;
  final LocationDatasource _locationDatasource;

  @override
  Future<SiswaHomeSnapshot?> getHomeSummary() async {
    final dto = await _datasource.getHomeSummary();
    return dto?.toEntity();
  }

  @override
  Future<AttendanceRecord?> getTodayRecord() async {
    final dto = await _datasource.getTodayRecord();
    return dto?.toEntity();
  }

  @override
  Future<List<AttendanceRecord>> getAllRecords() async {
    final dtos = await _datasource.getAllRecords();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<GeofenceEvaluation> evaluateGeofence({
    required double targetLat,
    required double targetLng,
    required double allowedRadiusMeters,
  }) async {
    final reading = await _locationDatasource.getCurrentLocation(
      targetLat: targetLat,
      targetLng: targetLng,
    );
    final distanceMeters = haversineDistanceMeters(
      startLat: reading.latitude,
      startLng: reading.longitude,
      endLat: targetLat,
      endLng: targetLng,
    );
    return GeofenceEvaluation(
      distanceMeters: distanceMeters,
      allowedRadiusMeters: allowedRadiusMeters,
      isWithinRadius: distanceMeters <= allowedRadiusMeters,
      isMocked: reading.isMocked,
      evaluatedAt: DateTime.now(),
      location: reading,
    );
  }

  @override
  Future<AttendanceRecord> submitCheckIn({
    required LocationReading location,
    required double distanceMeters,
    required double allowedRadiusMeters,
    required String selfieLabel,
    required String workStartTime,
  }) async {
    _guardIntegrity(
      location: location,
      distanceMeters: distanceMeters,
      allowedRadiusMeters: allowedRadiusMeters,
    );

    final dto = await _datasource.submitCheckIn(
      payload: CheckInPayloadDto(
        latitude: location.latitude,
        longitude: location.longitude,
        accuracyMeters: location.accuracyMeters,
        distanceMeters: distanceMeters,
        isMocked: location.isMocked,
        selfieLabel: selfieLabel,
        capturedAtIso: DateTime.now().toIso8601String(),
      ),
      workStartTime: workStartTime,
    );
    return dto.toEntity();
  }

  @override
  Future<AttendanceRecord> submitCheckOut({
    required LocationReading location,
    required double distanceMeters,
    required double allowedRadiusMeters,
    required String selfieLabel,
  }) async {
    _guardIntegrity(
      location: location,
      distanceMeters: distanceMeters,
      allowedRadiusMeters: allowedRadiusMeters,
    );

    final dto = await _datasource.submitCheckOut(
      payload: CheckInPayloadDto(
        latitude: location.latitude,
        longitude: location.longitude,
        accuracyMeters: location.accuracyMeters,
        distanceMeters: distanceMeters,
        isMocked: location.isMocked,
        selfieLabel: selfieLabel,
        capturedAtIso: DateTime.now().toIso8601String(),
      ),
    );
    return dto.toEntity();
  }

  void _guardIntegrity({
    required LocationReading location,
    required double distanceMeters,
    required double allowedRadiusMeters,
  }) {
    if (location.isMocked) {
      throw const AppError.mockLocationDetected(
        message:
            'Lokasi palsu (Fake GPS) terdeteksi. Nonaktifkan aplikasi lokasi tiruan.',
      );
    }
    if (distanceMeters > allowedRadiusMeters) {
      throw AppError.outOfGeofence(
        distanceMeters: distanceMeters,
        radiusMeters: allowedRadiusMeters,
      );
    }
  }
}

@Riverpod(keepAlive: true)
AttendanceDatasource attendanceDatasource(Ref ref) => AppConfig.useDemoMode
    ? DemoAttendanceDatasource()
    : RemoteAttendanceDatasource(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AttendanceRepository attendanceRepository(Ref ref) => AttendanceRepositoryImpl(
      datasource: ref.watch(attendanceDatasourceProvider),
      locationDatasource: ref.watch(locationDatasourceProvider),
    );
