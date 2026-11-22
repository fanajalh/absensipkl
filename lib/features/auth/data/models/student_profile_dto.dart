import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/student_profile.dart';
import 'dudi_placement_dto.dart';

part 'student_profile_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentProfileDto {
  const StudentProfileDto({
    required this.id,
    required this.nisn,
    required this.fullName,
    required this.className,
    required this.major,
    required this.email,
    required this.placement,
  });

  factory StudentProfileDto.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileDtoFromJson(json);

  factory StudentProfileDto.fromEntity(StudentProfile entity) =>
      StudentProfileDto(
        id: entity.id,
        nisn: entity.nisn,
        fullName: entity.fullName,
        className: entity.className,
        major: entity.major,
        email: entity.email,
        placement: DudiPlacementDto.fromEntity(entity.placement),
      );

  final String id;
  final String nisn;
  final String fullName;
  final String className;
  final String major;
  final String email;
  final DudiPlacementDto placement;

  Map<String, dynamic> toJson() => _$StudentProfileDtoToJson(this);

  StudentProfile toEntity() => StudentProfile(
        id: id,
        nisn: nisn,
        fullName: fullName,
        className: className,
        major: major,
        email: email,
        placement: placement.toEntity(),
      );
}
