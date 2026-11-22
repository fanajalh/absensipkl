import 'package:json_annotation/json_annotation.dart';

import '../../../attendance/data/models/attendance_record_dto.dart';
import '../../domain/entities/attendance_recap.dart';

part 'attendance_recap_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AttendanceRecapDto {
  const AttendanceRecapDto({
    required this.totalDays,
    required this.presentCount,
    required this.lateCount,
    required this.leaveCount,
    required this.absentCount,
    required this.attendancePercentage,
    required this.records,
  });

  factory AttendanceRecapDto.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecapDtoFromJson(json);

  final int totalDays;
  final int presentCount;
  final int lateCount;
  final int leaveCount;
  final int absentCount;
  final double attendancePercentage;
  final List<AttendanceRecordDto> records;

  Map<String, dynamic> toJson() => _$AttendanceRecapDtoToJson(this);

  AttendanceRecap toEntity() => AttendanceRecap(
        totalDays: totalDays,
        presentCount: presentCount,
        lateCount: lateCount,
        leaveCount: leaveCount,
        absentCount: absentCount,
        attendancePercentage: attendancePercentage,
        records: records.map((dto) => dto.toEntity()).toList(growable: false),
      );
}
