import '../../../attendance/data/datasources/attendance_datasource.dart';
import '../../../attendance/data/models/attendance_record_dto.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../domain/entities/history_filter.dart';
import '../models/attendance_recap_dto.dart';
import 'history_datasource.dart';

/// Computes monthly KPIs & filtered history directly from [AttendanceDatasource].
class DemoHistoryDatasource implements HistoryDatasource {
  DemoHistoryDatasource(this._attendanceDatasource);

  final AttendanceDatasource _attendanceDatasource;

  @override
  Future<AttendanceRecapDto> getMonthlyRecap({
    required int year,
    required int month,
    HistoryFilter filter = HistoryFilter.all,
  }) async {
    final all = await _attendanceDatasource.getAllRecords();
    final monthRecords = all.where((dto) {
      final date = DateTime.parse(dto.dateIso);
      return date.year == year && date.month == month;
    }).toList(growable: false);

    var presentCount = 0;
    var lateCount = 0;
    var leaveCount = 0;
    var absentCount = 0;

    for (final dto in monthRecords) {
      if (dto.statusName == AttendanceStatus.present.name) {
        presentCount++;
      } else if (dto.statusName == AttendanceStatus.late.name) {
        lateCount++;
      } else if (dto.statusName == AttendanceStatus.leave.name) {
        leaveCount++;
      } else if (dto.statusName == AttendanceStatus.absent.name) {
        absentCount++;
      }
    }

    final totalDays = monthRecords.length;
    final attendancePercentage = totalDays == 0
        ? 0.0
        : ((presentCount + lateCount) / totalDays) * 100.0;

    final filtered = switch (filter) {
      HistoryFilter.all => monthRecords,
      HistoryFilter.present => _filterByStatus(
          monthRecords,
          AttendanceStatus.present,
        ),
      HistoryFilter.late => _filterByStatus(
          monthRecords,
          AttendanceStatus.late,
        ),
      HistoryFilter.leave => _filterByStatus(
          monthRecords,
          AttendanceStatus.leave,
        ),
      HistoryFilter.absent => _filterByStatus(
          monthRecords,
          AttendanceStatus.absent,
        ),
    };

    return AttendanceRecapDto(
      totalDays: totalDays,
      presentCount: presentCount,
      lateCount: lateCount,
      leaveCount: leaveCount,
      absentCount: absentCount,
      attendancePercentage: attendancePercentage,
      records: filtered,
    );
  }

  List<AttendanceRecordDto> _filterByStatus(
    List<AttendanceRecordDto> records,
    AttendanceStatus status,
  ) =>
      records
          .where((dto) => dto.statusName == status.name)
          .toList(growable: false);
}
