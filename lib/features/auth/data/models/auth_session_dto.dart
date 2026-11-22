import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_session.dart';
import 'student_profile_dto.dart';

part 'auth_session_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.issuedAtIso,
    required this.expiresAtIso,
    required this.student,
  });

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  factory AuthSessionDto.fromEntity(AuthSession entity) => AuthSessionDto(
        accessToken: entity.accessToken,
        issuedAtIso: entity.issuedAt.toIso8601String(),
        expiresAtIso: entity.expiresAt.toIso8601String(),
        student: StudentProfileDto.fromEntity(entity.student),
      );

  final String accessToken;
  final String issuedAtIso;
  final String expiresAtIso;
  final StudentProfileDto student;

  Map<String, dynamic> toJson() => _$AuthSessionDtoToJson(this);

  AuthSession toEntity() => AuthSession(
        accessToken: accessToken,
        issuedAt: DateTime.parse(issuedAtIso),
        expiresAt: DateTime.parse(expiresAtIso),
        student: student.toEntity(),
      );
}
