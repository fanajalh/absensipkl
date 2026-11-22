import '../entities/auth_session.dart';

/// Authentication contract isolating presentation from storage/network details.
abstract interface class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthSession> login({
    required String identifier,
    required String password,
  });

  Future<void> logout();
}
