import '../models/attendance_record_dto.dart';
import '../models/check_in_payload_dto.dart';
import '../models/siswa_home_dto.dart';

/// Contract for attendance record storage, home snapshot & check-in/out.
abstract interface class AttendanceDatasource {
  Future<SiswaHomeDto?> getHomeSummary() async => null;

  Future<AttendanceRecordDto?> getTodayRecord();

  Future<List<AttendanceRecordDto>> getAllRecords();

  Future<AttendanceRecordDto> submitCheckIn({
    required CheckInPayloadDto payload,
    required String workStartTime,
  });

  Future<AttendanceRecordDto> submitCheckOut({
    required CheckInPayloadDto payload,
  });
}
