import '../entities/leave_request.dart';

/// Contract for submitting and retrieving PKL leave requests.
abstract interface class LeaveRepository {
  Future<List<LeaveRequest>> getRequests();

  Future<LeaveRequest> submitRequest(LeaveRequest request);
}
