import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/features/leave/data/datasources/demo_leave_datasource.dart';
import 'package:absensi_pkl/features/leave/data/datasources/leave_datasource.dart';
import 'package:absensi_pkl/features/leave/data/models/leave_request_dto.dart';
import 'package:absensi_pkl/features/leave/domain/entities/leave_approval_status.dart';
import 'package:absensi_pkl/features/leave/domain/entities/leave_request.dart';
import 'package:absensi_pkl/features/leave/domain/entities/leave_type.dart';
import 'package:absensi_pkl/features/leave/presentation/notifiers/leave_notifier.dart';
import 'package:absensi_pkl/features/leave/repositories/leave_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingRefreshLeaveDatasource implements LeaveDatasource {
  bool shouldFail = false;

  @override
  Future<List<LeaveRequestDto>> getRequests() async {
    if (shouldFail) {
      throw const AppError.network(message: 'Gagal memuat riwayat pengajuan izin.');
    }
    return <LeaveRequestDto>[];
  }

  @override
  Future<LeaveRequestDto> submitRequest(LeaveRequestDto request) async =>
      request;
}

LeaveRequest _buildRequest({
  DateTime? startDate,
  DateTime? endDate,
  String reason = 'Mengikuti seminar kejuruan tingkat provinsi.',
}) {
  final start = startDate ?? DateTime(2026, 4, 16);
  final end = endDate ?? DateTime(2026, 4, 17);
  return LeaveRequest(
    id: '',
    type: LeaveType.izin,
    startDate: start,
    endDate: end,
    reason: reason,
    status: LeaveApprovalStatus.submitted,
    submittedAt: DateTime(2026, 4, 15, 9),
  );
}

void main() {
  group('LeaveNotifier', () {
    test('rejects request when endDate is earlier than startDate', () async {
      final container = ProviderContainer.test(
        overrides: [
          leaveDatasourceProvider.overrideWithValue(
            DemoLeaveDatasource(clock: () => DateTime(2026, 4, 15, 9)),
          ),
        ],
      );

      await container.read(leaveProvider.future);

      await expectLater(
        () => container.read(leaveProvider.notifier).submitRequest(
              _buildRequest(
                startDate: DateTime(2026, 4, 18),
                endDate: DateTime(2026, 4, 16),
              ),
            ),
        throwsA(
          isA<ValidationError>().having(
            (e) => e.message,
            'message',
            contains('Tanggal selesai tidak boleh lebih awal'),
          ),
        ),
      );
    });

    test('rejects request when reason is shorter than 10 characters', () async {
      final container = ProviderContainer.test(
        overrides: [
          leaveDatasourceProvider.overrideWithValue(
            DemoLeaveDatasource(clock: () => DateTime(2026, 4, 15, 9)),
          ),
        ],
      );

      await container.read(leaveProvider.future);

      await expectLater(
        () => container.read(leaveProvider.notifier).submitRequest(
              _buildRequest(reason: 'Sakit'),
            ),
        throwsA(isA<ValidationError>()),
      );
    });

    test('submits valid leave request and adds it to notifier state', () async {
      final container = ProviderContainer.test(
        overrides: [
          leaveDatasourceProvider.overrideWithValue(
            DemoLeaveDatasource(clock: () => DateTime(2026, 4, 15, 9)),
          ),
        ],
      );

      final initial = await container.read(leaveProvider.future);
      expect(initial.length, equals(2));

      await container
          .read(leaveProvider.notifier)
          .submitRequest(_buildRequest());

      final updated = container.read(leaveProvider).requireValue;
      expect(updated.length, equals(3));
      expect(
        updated.first.reason,
        equals('Mengikuti seminar kejuruan tingkat provinsi.'),
      );
      expect(updated.first.status, equals(LeaveApprovalStatus.submitted));
    });

    test('surfaces AsyncError on refresh failure rather than hanging in loading',
        () async {
      final datasource = _FailingRefreshLeaveDatasource();
      final container = ProviderContainer.test(
        overrides: [
          leaveDatasourceProvider.overrideWithValue(datasource),
        ],
      );

      await container.read(leaveProvider.future);

      datasource.shouldFail = true;
      await container.read(leaveProvider.notifier).refresh();

      final state = container.read(leaveProvider);
      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.error, isA<NetworkError>());
    });
  });
}
