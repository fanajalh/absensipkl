// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestDto _$LeaveRequestDtoFromJson(Map<String, dynamic> json) =>
    LeaveRequestDto(
      id: json['id'] as String,
      typeName: json['typeName'] as String,
      startDateIso: json['startDateIso'] as String,
      endDateIso: json['endDateIso'] as String,
      reason: json['reason'] as String,
      attachmentName: json['attachmentName'] as String?,
      statusName: json['statusName'] as String,
      submittedAtIso: json['submittedAtIso'] as String,
    );

Map<String, dynamic> _$LeaveRequestDtoToJson(LeaveRequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
      'startDateIso': instance.startDateIso,
      'endDateIso': instance.endDateIso,
      'reason': instance.reason,
      'attachmentName': instance.attachmentName,
      'statusName': instance.statusName,
      'submittedAtIso': instance.submittedAtIso,
    };
