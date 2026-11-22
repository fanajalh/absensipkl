import '../entities/attendance_recap.dart';
import '../entities/history_filter.dart';

/// Contract for computing monthly attendance KPI summaries & filtered logs.
abstract interface class HistoryRepository {
  Future<AttendanceRecap> getMonthlyRecap({
    required int year,
    required int month,
    HistoryFilter filter = HistoryFilter.all,
  });
}
