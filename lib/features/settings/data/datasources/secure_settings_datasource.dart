import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/secure_storage_datasource.dart';
import '../models/app_settings_dto.dart';
import 'settings_datasource.dart';

/// Persists [AppSettingsDto] in [SecureStorageDatasource].
class SecureSettingsDatasource implements SettingsDatasource {
  SecureSettingsDatasource(this._storage);

  final SecureStorageDatasource _storage;

  @override
  Future<AppSettingsDto> readSettings() async {
    final raw = await _storage.read(StorageKeys.appSettings);
    if (raw == null || raw.isEmpty) {
      return const AppSettingsDto();
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettingsDto.fromJson(decoded);
    } catch (_) {
      return const AppSettingsDto();
    }
  }

  @override
  Future<void> writeSettings(AppSettingsDto dto) async {
    final encoded = jsonEncode(dto.toJson());
    await _storage.write(StorageKeys.appSettings, encoded);
  }
}
