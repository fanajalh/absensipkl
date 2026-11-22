import '../../domain/entities/history_filter.dart';
import '../models/attendance_recap_dto.dart';

/// Contract for fetching monthly KPI summaries & filtered attendance logs.
abstract interface class HistoryDatasource {
  Future<AttendanceRecapDto> getMonthlyRecap({
    required int year,
    required int month,
    HistoryFilter filter = HistoryFilter.all,
  });
}
