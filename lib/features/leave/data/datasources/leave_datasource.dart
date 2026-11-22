import '../models/leave_request_dto.dart';

/// Contract for PKL student leave request persistence.
abstract interface class LeaveDatasource {
  Future<List<LeaveRequestDto>> getRequests();

  Future<LeaveRequestDto> submitRequest(LeaveRequestDto request);
}
