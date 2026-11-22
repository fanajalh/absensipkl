import '../models/auth_session_dto.dart';

/// Remote/demo authentication contract.
abstract interface class AuthDatasource {
  Future<AuthSessionDto> login({
    required String identifier,
    required String password,
  });

  Future<void> logout();
}

/// Encrypted local session cache contract.
abstract interface class LocalAuthDatasource {
  Future<AuthSessionDto?> readSession();

  Future<void> saveSession(AuthSessionDto session);

  Future<void> clearSession();
}
