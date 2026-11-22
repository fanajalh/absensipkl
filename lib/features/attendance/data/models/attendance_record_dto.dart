import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_status.dart';

part 'attendance_record_dto.g.dart';

@JsonSerializable()
class AttendanceRecordDto {
  const AttendanceRecordDto({
    required this.id,
    required this.dateIso,
    required this.statusName,
    this.checkInTimeIso,
    this.checkOutTimeIso,
    this.checkInDistanceMeters,
    this.checkOutDistanceMeters,
    this.isMockLocationFlagged = false,
    this.selfieLabel,
    this.notes,
  });

  factory AttendanceRecordDto.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordDtoFromJson(json);

  factory AttendanceRecordDto.fromEntity(AttendanceRecord entity) =>
      AttendanceRecordDto(
        id: entity.id,
        dateIso: entity.date.toIso8601String(),
        statusName: entity.status.name,
        checkInTimeIso: entity.checkInTime?.toIso8601String(),
        checkOutTimeIso: entity.checkOutTime?.toIso8601String(),
        checkInDistanceMeters: entity.checkInDistanceMeters,
        checkOutDistanceMeters: entity.checkOutDistanceMeters,
        isMockLocationFlagged: entity.isMockLocationFlagged,
        selfieLabel: entity.selfieLabel,
        notes: entity.notes,
      );

  final String id;
  final String dateIso;
  final String statusName;
  final String? checkInTimeIso;
  final String? checkOutTimeIso;
  final double? checkInDistanceMeters;
  final double? checkOutDistanceMeters;
  final bool isMockLocationFlagged;
  final String? selfieLabel;
  final String? notes;

  Map<String, dynamic> toJson() => _$AttendanceRecordDtoToJson(this);

  AttendanceRecord toEntity() => AttendanceRecord(
        id: id,
        date: DateTime.parse(dateIso),
        status: AttendanceStatus.values.firstWhere(
          (value) => value.name == statusName,
          orElse: () => AttendanceStatus.present,
        ),
        checkInTime:
            checkInTimeIso == null ? null : DateTime.parse(checkInTimeIso!),
        checkOutTime:
            checkOutTimeIso == null ? null : DateTime.parse(checkOutTimeIso!),
        checkInDistanceMeters: checkInDistanceMeters,
        checkOutDistanceMeters: checkOutDistanceMeters,
        isMockLocationFlagged: isMockLocationFlagged,
        selfieLabel: selfieLabel,
        notes: notes,
      );
}
