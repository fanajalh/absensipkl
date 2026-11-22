// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfileDto _$StudentProfileDtoFromJson(Map<String, dynamic> json) =>
    StudentProfileDto(
      id: json['id'] as String,
      nisn: json['nisn'] as String,
      fullName: json['fullName'] as String,
      className: json['className'] as String,
      major: json['major'] as String,
      email: json['email'] as String,
      placement: DudiPlacementDto.fromJson(
        json['placement'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$StudentProfileDtoToJson(StudentProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nisn': instance.nisn,
      'fullName': instance.fullName,
      'className': instance.className,
      'major': instance.major,
      'email': instance.email,
      'placement': instance.placement.toJson(),
    };
