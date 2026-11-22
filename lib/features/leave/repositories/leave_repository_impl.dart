import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../data/datasources/demo_leave_datasource.dart';
import '../data/datasources/leave_datasource.dart';
import '../data/datasources/remote_leave_datasource.dart';
import '../data/models/leave_request_dto.dart';
import '../domain/entities/leave_request.dart';
import '../domain/repositories/leave_repository.dart';

part 'leave_repository_impl.g.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl(this._datasource);

  final LeaveDatasource _datasource;

  @override
  Future<List<LeaveRequest>> getRequests() async {
    final dtos = await _datasource.getRequests();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<LeaveRequest> submitRequest(LeaveRequest request) async {
    final start = DateTime(
      request.startDate.year,
      request.startDate.month,
      request.startDate.day,
    );
    final end = DateTime(
      request.endDate.year,
      request.endDate.month,
      request.endDate.day,
    );

    if (end.isBefore(start)) {
      throw const AppError.validation(
        message: 'Tanggal selesai tidak boleh lebih awal dari tanggal mulai.',
      );
    }

    final reason = request.reason.trim();
    if (reason.length < 10) {
      throw const AppError.validation(
        message: 'Keterangan minimal 10 karakter.',
      );
    }

    final dto = await _datasource.submitRequest(
      LeaveRequestDto.fromEntity(
        request.copyWith(
          startDate: start,
          endDate: end,
          reason: reason,
        ),
      ),
    );
    return dto.toEntity();
  }
}

@Riverpod(keepAlive: true)
LeaveDatasource leaveDatasource(Ref ref) => AppConfig.useDemoMode
    ? DemoLeaveDatasource()
    : RemoteLeaveDatasource(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
LeaveRepository leaveRepository(Ref ref) =>
    LeaveRepositoryImpl(ref.watch(leaveDatasourceProvider));
