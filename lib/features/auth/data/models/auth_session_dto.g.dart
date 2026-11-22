// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    AuthSessionDto(
      accessToken: json['accessToken'] as String,
      issuedAtIso: json['issuedAtIso'] as String,
      expiresAtIso: json['expiresAtIso'] as String,
      student: StudentProfileDto.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AuthSessionDtoToJson(AuthSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'issuedAtIso': instance.issuedAtIso,
      'expiresAtIso': instance.expiresAtIso,
      'student': instance.student.toJson(),
    };
