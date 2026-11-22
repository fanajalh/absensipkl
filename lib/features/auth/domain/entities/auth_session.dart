import 'package:freezed_annotation/freezed_annotation.dart';

import 'student_profile.dart';

part 'auth_session.freezed.dart';

/// Pure domain entity representing an active student authentication session.
@freezed
abstract class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    required String accessToken,
    required DateTime issuedAt,
    required DateTime expiresAt,
    required StudentProfile student,
  }) = _AuthSession;

  bool isExpiredAt(DateTime now) => !now.isBefore(expiresAt);
}
