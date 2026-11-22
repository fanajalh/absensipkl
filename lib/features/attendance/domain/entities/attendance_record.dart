import 'package:freezed_annotation/freezed_annotation.dart';

import 'attendance_status.dart';

part 'attendance_record.freezed.dart';

/// Pure domain entity representing a single day's PKL attendance record.
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const AttendanceRecord._();

  const factory AttendanceRecord({
    required String id,
    required DateTime date,
    required AttendanceStatus status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? checkInDistanceMeters,
    double? checkOutDistanceMeters,
    @Default(false) bool isMockLocationFlagged,
    String? selfieLabel,
    String? notes,
  }) = _AttendanceRecord;

  bool get hasCheckedIn => checkInTime != null;
  bool get hasCheckedOut => checkOutTime != null;
}
