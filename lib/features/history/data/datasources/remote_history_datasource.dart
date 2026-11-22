import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../../attendance/data/models/siswa_home_dto.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/history_filter.dart';
import '../models/attendance_recap_dto.dart';
import 'history_datasource.dart';

/// Production REST datasource communicating with `/siswa/history`.
class RemoteHistoryDatasource implements HistoryDatasource {
  RemoteHistoryDatasource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AttendanceRecapDto> getMonthlyRecap({
    required int year,
    required int month,
    HistoryFilter filter = HistoryFilter.all,
  }) async {
    final response = await _apiClient.get(
      ApiPaths.history,
      queryParams: <String, String>{
        'year': year.toString(),
        'month': month.toString(),
      },
    );
    final data = _unwrapData(response);
    final rawList = (data['records'] as List<dynamic>?) ?? const <dynamic>[];
    final records = rawList
        .whereType<Map<String, dynamic>>()
        .map(SiswaHomeDto.parseAttendanceJson)
        .toList(growable: false);

    final recapRaw = data['recap'] as Map<String, dynamic>?;
    final presentCount = (recapRaw?['presentCount'] as num?)?.toInt() ??
        records.where((r) => r.statusName == AttendanceStatus.present.name).length;
    final lateCount = (recapRaw?['lateCount'] as num?)?.toInt() ??
        records.where((r) => r.statusName == AttendanceStatus.late.name).length;
    final leaveCount = (recapRaw?['leaveCount'] as num?)?.toInt() ??
        records.where((r) => r.statusName == AttendanceStatus.leave.name).length;
    final absentCount = (recapRaw?['absentCount'] as num?)?.toInt() ??
        records.where((r) => r.statusName == AttendanceStatus.absent.name).length;

    final totalDays = records.isNotEmpty
        ? records.length
        : presentCount + lateCount + leaveCount + absentCount;
    final percentage = totalDays == 0
        ? 0.0
        : ((presentCount + lateCount) / totalDays) * 100.0;

    final filtered = switch (filter) {
      HistoryFilter.all => records,
      HistoryFilter.present =>
        records.where((r) => r.statusName == AttendanceStatus.present.name).toList(growable: false),
      HistoryFilter.late =>
        records.where((r) => r.statusName == AttendanceStatus.late.name).toList(growable: false),
      HistoryFilter.leave =>
        records.where((r) => r.statusName == AttendanceStatus.leave.name).toList(growable: false),
      HistoryFilter.absent =>
        records.where((r) => r.statusName == AttendanceStatus.absent.name).toList(growable: false),
    };

    return AttendanceRecapDto(
      totalDays: totalDays,
      presentCount: presentCount,
      lateCount: lateCount,
      leaveCount: leaveCount,
      absentCount: absentCount,
      attendancePercentage: percentage,
      records: filtered,
    );
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> response) {
    final nested = response['data'];
    if (nested is Map<String, dynamic>) return nested;
    return response;
  }
}
