import 'package:freezed_annotation/freezed_annotation.dart';

import 'leave_approval_status.dart';
import 'leave_type.dart';

part 'leave_request.freezed.dart';

/// Pure domain entity for a PKL student leave/sick request.
@freezed
abstract class LeaveRequest with _$LeaveRequest {
  const LeaveRequest._();

  const factory LeaveRequest({
    required String id,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? attachmentName,
    required LeaveApprovalStatus status,
    required DateTime submittedAt,
  }) = _LeaveRequest;

  int get totalDays => endDate.difference(startDate).inDays + 1;
}
