import '../entities/attendance_record.dart';
import '../entities/geofence_evaluation.dart';
import '../entities/location_reading.dart';
import '../entities/siswa_home_snapshot.dart';

/// Contract for GPS geofence evaluation, home summary, and check-in/out.
abstract interface class AttendanceRepository {
  Future<SiswaHomeSnapshot?> getHomeSummary();

  Future<AttendanceRecord?> getTodayRecord();

  Future<List<AttendanceRecord>> getAllRecords();

  Future<GeofenceEvaluation> evaluateGeofence({
    required double targetLat,
    required double targetLng,
    required double allowedRadiusMeters,
  });

  Future<AttendanceRecord> submitCheckIn({
    required LocationReading location,
    required double distanceMeters,
    required double allowedRadiusMeters,
    required String selfieLabel,
    required String workStartTime,
  });

  Future<AttendanceRecord> submitCheckOut({
    required LocationReading location,
    required double distanceMeters,
    required double allowedRadiusMeters,
    required String selfieLabel,
  });
}
