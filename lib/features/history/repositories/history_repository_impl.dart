import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../attendance/data/datasources/remote_attendance_datasource.dart';
import '../../attendance/repositories/attendance_repository_impl.dart';
import '../data/datasources/demo_history_datasource.dart';
import '../data/datasources/history_datasource.dart';
import '../data/datasources/remote_history_datasource.dart';
import '../domain/entities/attendance_recap.dart';
import '../domain/entities/history_filter.dart';
import '../domain/repositories/history_repository.dart';

part 'history_repository_impl.g.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._datasource);

  final HistoryDatasource _datasource;

  @override
  Future<AttendanceRecap> getMonthlyRecap({
    required int year,
    required int month,
    HistoryFilter filter = HistoryFilter.all,
  }) async {
    final dto = await _datasource.getMonthlyRecap(
      year: year,
      month: month,
      filter: filter,
    );
    return dto.toEntity();
  }
}

@Riverpod(keepAlive: true)
HistoryDatasource historyDatasource(Ref ref) {
  final attendanceDs = ref.watch(attendanceDatasourceProvider);
  if (AppConfig.useDemoMode || attendanceDs is! RemoteAttendanceDatasource) {
    return DemoHistoryDatasource(attendanceDs);
  }
  return RemoteHistoryDatasource(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(Ref ref) =>
    HistoryRepositoryImpl(ref.watch(historyDatasourceProvider));
