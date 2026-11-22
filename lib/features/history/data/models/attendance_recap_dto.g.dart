// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_recap_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecapDto _$AttendanceRecapDtoFromJson(Map<String, dynamic> json) =>
    AttendanceRecapDto(
      totalDays: (json['totalDays'] as num).toInt(),
      presentCount: (json['presentCount'] as num).toInt(),
      lateCount: (json['lateCount'] as num).toInt(),
      leaveCount: (json['leaveCount'] as num).toInt(),
      absentCount: (json['absentCount'] as num).toInt(),
      attendancePercentage: (json['attendancePercentage'] as num).toDouble(),
      records: (json['records'] as List<dynamic>)
          .map((e) => AttendanceRecordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceRecapDtoToJson(AttendanceRecapDto instance) =>
    <String, dynamic>{
      'totalDays': instance.totalDays,
      'presentCount': instance.presentCount,
      'lateCount': instance.lateCount,
      'leaveCount': instance.leaveCount,
      'absentCount': instance.absentCount,
      'attendancePercentage': instance.attendancePercentage,
      'records': instance.records.map((e) => e.toJson()).toList(),
    };
