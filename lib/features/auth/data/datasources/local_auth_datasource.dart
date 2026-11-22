import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/services/secure_storage_datasource.dart';
import '../models/auth_session_dto.dart';
import 'auth_datasource.dart';

/// Persists authentication sessions exclusively in [SecureStorageDatasource].
class SecureLocalAuthDatasource implements LocalAuthDatasource {
  SecureLocalAuthDatasource(this._storage);

  final SecureStorageDatasource _storage;

  @override
  Future<AuthSessionDto?> readSession() async {
    final raw = await _storage.read(StorageKeys.authSession);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AuthSessionDto.fromJson(decoded);
    } catch (_) {
      await _storage.delete(StorageKeys.authSession);
      throw const AppError.storage(
        message: 'Sesi tersimpan rusak dan telah direset. Silakan masuk ulang.',
      );
    }
  }

  @override
  Future<void> saveSession(AuthSessionDto session) async {
    final encoded = jsonEncode(session.toJson());
    await _storage.write(StorageKeys.authSession, encoded);
  }

  @override
  Future<void> clearSession() => _storage.delete(StorageKeys.authSession);
}
