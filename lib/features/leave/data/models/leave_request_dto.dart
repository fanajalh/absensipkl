import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_request.dart';
import '../../domain/entities/leave_type.dart';

part 'leave_request_dto.g.dart';

@JsonSerializable()
class LeaveRequestDto {
  const LeaveRequestDto({
    required this.id,
    required this.typeName,
    required this.startDateIso,
    required this.endDateIso,
    required this.reason,
    this.attachmentName,
    required this.statusName,
    required this.submittedAtIso,
  });

  factory LeaveRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestDtoFromJson(json);

  factory LeaveRequestDto.fromEntity(LeaveRequest entity) => LeaveRequestDto(
        id: entity.id,
        typeName: entity.type.name,
        startDateIso: entity.startDate.toIso8601String(),
        endDateIso: entity.endDate.toIso8601String(),
        reason: entity.reason,
        attachmentName: entity.attachmentName,
        statusName: entity.status.name,
        submittedAtIso: entity.submittedAt.toIso8601String(),
      );

  final String id;
  final String typeName;
  final String startDateIso;
  final String endDateIso;
  final String reason;
  final String? attachmentName;
  final String statusName;
  final String submittedAtIso;

  Map<String, dynamic> toJson() => _$LeaveRequestDtoToJson(this);

  LeaveRequest toEntity() => LeaveRequest(
        id: id,
        type: LeaveType.values.firstWhere(
          (value) => value.name == typeName,
          orElse: () => LeaveType.izin,
        ),
        startDate: DateTime.parse(startDateIso),
        endDate: DateTime.parse(endDateIso),
        reason: reason,
        attachmentName: attachmentName,
        status: LeaveApprovalStatus.values.firstWhere(
          (value) => value.name == statusName,
          orElse: () => LeaveApprovalStatus.submitted,
        ),
        submittedAt: DateTime.parse(submittedAtIso),
      );
}
