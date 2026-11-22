import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../attendance/domain/entities/attendance_record.dart';

part 'attendance_recap.freezed.dart';

/// Pure domain KPI summary & filtered records for monthly attendance recap.
@freezed
abstract class AttendanceRecap with _$AttendanceRecap {
  const factory AttendanceRecap({
    required int totalDays,
    required int presentCount,
    required int lateCount,
    required int leaveCount,
    required int absentCount,
    required double attendancePercentage,
    required List<AttendanceRecord> records,
  }) = _AttendanceRecap;
}
