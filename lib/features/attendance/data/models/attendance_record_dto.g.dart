// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordDto _$AttendanceRecordDtoFromJson(
  Map<String, dynamic> json,
) => AttendanceRecordDto(
  id: json['id'] as String,
  dateIso: json['dateIso'] as String,
  statusName: json['statusName'] as String,
  checkInTimeIso: json['checkInTimeIso'] as String?,
  checkOutTimeIso: json['checkOutTimeIso'] as String?,
  checkInDistanceMeters: (json['checkInDistanceMeters'] as num?)?.toDouble(),
  checkOutDistanceMeters: (json['checkOutDistanceMeters'] as num?)?.toDouble(),
  isMockLocationFlagged: json['isMockLocationFlagged'] as bool? ?? false,
  selfieLabel: json['selfieLabel'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$AttendanceRecordDtoToJson(
  AttendanceRecordDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'dateIso': instance.dateIso,
  'statusName': instance.statusName,
  'checkInTimeIso': instance.checkInTimeIso,
  'checkOutTimeIso': instance.checkOutTimeIso,
  'checkInDistanceMeters': instance.checkInDistanceMeters,
  'checkOutDistanceMeters': instance.checkOutDistanceMeters,
  'isMockLocationFlagged': instance.isMockLocationFlagged,
  'selfieLabel': instance.selfieLabel,
  'notes': instance.notes,
};
