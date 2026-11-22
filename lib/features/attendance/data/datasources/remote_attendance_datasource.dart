import '../../../../core/constants/api_paths.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/api_client.dart';
import '../models/attendance_record_dto.dart';
import '../models/check_in_payload_dto.dart';
import '../models/siswa_home_dto.dart';
import 'attendance_datasource.dart';

/// Production REST datasource communicating with `/siswa/home`, `/siswa/check-in`,
/// `/siswa/check-out`, and `/siswa/history`.
class RemoteAttendanceDatasource implements AttendanceDatasource {
  RemoteAttendanceDatasource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<SiswaHomeDto?> getHomeSummary() async {
    final response = await _apiClient.get(ApiPaths.siswaHome);
    final data = _unwrapData(response);
    return SiswaHomeDto.fromJson(data);
  }

  @override
  Future<AttendanceRecordDto?> getTodayRecord() async {
    final summary = await getHomeSummary();
    return summary?.todayRecord;
  }

  @override
  Future<List<AttendanceRecordDto>> getAllRecords() async {
    final response = await _apiClient.get(ApiPaths.history);
    final data = _unwrapData(response);
    final rawList = (data['records'] as List<dynamic>?) ?? const <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(SiswaHomeDto.parseAttendanceJson)
        .toList(growable: false);
  }

  @override
  Future<AttendanceRecordDto> submitCheckIn({
    required CheckInPayloadDto payload,
    required String workStartTime,
  }) async {
    final response = await _apiClient.post(
      ApiPaths.checkIn,
      body: <String, dynamic>{
        'latitude': payload.latitude,
        'longitude': payload.longitude,
        'isMockGps': payload.isMocked,
        'selfieUrl': payload.selfieLabel,
      },
    );
    final data = _unwrapData(response);
    final attendance =
        (data['attendance'] as Map<String, dynamic>?) ?? data;
    if (attendance.isEmpty) {
      throw const AppError.unexpected(
        message: 'Respon check-in server tidak valid.',
      );
    }
    return SiswaHomeDto.parseAttendanceJson(attendance);
  }

  @override
  Future<AttendanceRecordDto> submitCheckOut({
    required CheckInPayloadDto payload,
  }) async {
    final response = await _apiClient.post(
      ApiPaths.checkOut,
      body: <String, dynamic>{
        'latitude': payload.latitude,
        'longitude': payload.longitude,
        'isMockGps': payload.isMocked,
        'selfieUrl': payload.selfieLabel,
      },
    );
    final data = _unwrapData(response);
    final attendance =
        (data['attendance'] as Map<String, dynamic>?) ?? data;
    if (attendance.isEmpty) {
      throw const AppError.unexpected(
        message: 'Respon check-out server tidak valid.',
      );
    }
    return SiswaHomeDto.parseAttendanceJson(attendance);
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> response) {
    final nested = response['data'];
    if (nested is Map<String, dynamic>) return nested;
    return response;
  }
}
