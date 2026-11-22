import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../errors/app_error.dart';

part 'secure_storage_datasource.g.dart';

/// Abstraction over encrypted key-value storage for session & sensitive data.
abstract interface class SecureStorageDatasource {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// Production implementation backed by [FlutterSecureStorage]
/// (iOS Keychain / Android Keystore / WebCrypto).
class FlutterSecureStorageDatasource implements SecureStorageDatasource {
  FlutterSecureStorageDatasource({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('SecureStorage read failed: $error');
      }
      throw const AppError.storage(
        message: 'Gagal membaca data sesi aman dari perangkat.',
      );
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('SecureStorage write failed: $error');
      }
      throw const AppError.storage(
        message: 'Gagal menyimpan data sesi aman ke perangkat.',
      );
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('SecureStorage delete failed: $error');
      }
      throw const AppError.storage(
        message: 'Gagal menghapus data sesi dari perangkat.',
      );
    }
  }
}

/// In-memory implementation for unit & widget tests without platform channels.
class InMemorySecureStorageDatasource implements SecureStorageDatasource {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }
}

@Riverpod(keepAlive: true)
SecureStorageDatasource secureStorageDatasource(Ref ref) =>
    FlutterSecureStorageDatasource();
