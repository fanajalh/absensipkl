import 'package:absensi_pkl/features/attendance/data/datasources/attendance_datasource.dart';
import 'package:absensi_pkl/features/attendance/data/models/attendance_record_dto.dart';
import 'package:absensi_pkl/features/attendance/data/models/check_in_payload_dto.dart';
import 'package:absensi_pkl/features/attendance/data/models/siswa_home_dto.dart';
import 'package:absensi_pkl/features/attendance/domain/entities/attendance_status.dart';
import 'package:absensi_pkl/features/attendance/repositories/attendance_repository_impl.dart';
import 'package:absensi_pkl/features/history/domain/entities/history_filter.dart';
import 'package:absensi_pkl/features/history/presentation/notifiers/history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SeededAttendanceDatasource implements AttendanceDatasource {
  _SeededAttendanceDatasource(this._records);

  final List<AttendanceRecordDto> _records;

  @override
  Future<SiswaHomeDto?> getHomeSummary() async => null;

  @override
  Future<List<AttendanceRecordDto>> getAllRecords() async => _records;

  @override
  Future<AttendanceRecordDto?> getTodayRecord() async => null;

  @override
  Future<AttendanceRecordDto> submitCheckIn({
    required CheckInPayloadDto payload,
    required String workStartTime,
  }) =>
      throw UnimplementedError();

  @override
  Future<AttendanceRecordDto> submitCheckOut({
    required CheckInPayloadDto payload,
  }) =>
      throw UnimplementedError();
}

void main() {
  group('HistoryNotifier', () {
    List<AttendanceRecordDto> buildCurrentMonthRecords() {
      final now = DateTime.now();
      return <AttendanceRecordDto>[
        AttendanceRecordDto(
          id: 'h-1',
          dateIso: DateTime(now.year, now.month, 1).toIso8601String(),
          statusName: AttendanceStatus.present.name,
        ),
        AttendanceRecordDto(
          id: 'h-2',
          dateIso: DateTime(now.year, now.month, 2).toIso8601String(),
          statusName: AttendanceStatus.present.name,
        ),
        AttendanceRecordDto(
          id: 'h-3',
          dateIso: DateTime(now.year, now.month, 3).toIso8601String(),
          statusName: AttendanceStatus.late.name,
        ),
        AttendanceRecordDto(
          id: 'h-4',
          dateIso: DateTime(now.year, now.month, 4).toIso8601String(),
          statusName: AttendanceStatus.leave.name,
        ),
        AttendanceRecordDto(
          id: 'h-5',
          dateIso: DateTime(now.year, now.month, 5).toIso8601String(),
          statusName: AttendanceStatus.absent.name,
        ),
      ];
    }

    test('computes accurate monthly KPI recap totals and attendance percentage',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          attendanceDatasourceProvider.overrideWithValue(
            _SeededAttendanceDatasource(buildCurrentMonthRecords()),
          ),
        ],
      );

      final viewState = await container.read(historyProvider.future);
      final recap = viewState.recap;

      expect(viewState.filter, equals(HistoryFilter.all));
      expect(recap.totalDays, equals(5));
      expect(recap.presentCount, equals(2));
      expect(recap.lateCount, equals(1));
      expect(recap.leaveCount, equals(1));
      expect(recap.absentCount, equals(1));
      expect(recap.attendancePercentage, closeTo(60.0, 0.01));
      expect(recap.records.length, equals(5));
    });

    test('filters records across all HistoryFilter chips while preserving KPIs',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          attendanceDatasourceProvider.overrideWithValue(
            _SeededAttendanceDatasource(buildCurrentMonthRecords()),
          ),
        ],
      );

      await container.read(historyProvider.future);
      final notifier = container.read(historyProvider.notifier);

      await notifier.setFilter(HistoryFilter.present);
      var state = container.read(historyProvider).requireValue;
      expect(state.filter, equals(HistoryFilter.present));
      expect(state.recap.records.map((r) => r.id).toList(), equals(['h-1', 'h-2']));
      expect(state.recap.totalDays, equals(5));

      await notifier.setFilter(HistoryFilter.late);
      state = container.read(historyProvider).requireValue;
      expect(state.recap.records.map((r) => r.id).toList(), equals(['h-3']));

      await notifier.setFilter(HistoryFilter.leave);
      state = container.read(historyProvider).requireValue;
      expect(state.recap.records.map((r) => r.id).toList(), equals(['h-4']));

      await notifier.setFilter(HistoryFilter.absent);
      state = container.read(historyProvider).requireValue;
      expect(state.recap.records.map((r) => r.id).toList(), equals(['h-5']));

      await notifier.setFilter(HistoryFilter.all);
      state = container.read(historyProvider).requireValue;
      expect(state.recap.records.length, equals(5));
    });
  });
}
