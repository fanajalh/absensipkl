import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/secure_storage_datasource.dart';
import '../data/datasources/secure_settings_datasource.dart';
import '../data/datasources/settings_datasource.dart';
import '../data/models/app_settings_dto.dart';
import '../domain/entities/app_settings.dart';
import '../domain/repositories/settings_repository.dart';

part 'settings_repository_impl.g.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._datasource);

  final SettingsDatasource _datasource;

  @override
  Future<AppSettings> loadSettings() async {
    final dto = await _datasource.readSettings();
    return dto.toEntity();
  }

  @override
  Future<AppSettings> saveSettings(AppSettings settings) async {
    await _datasource.writeSettings(AppSettingsDto.fromEntity(settings));
    return settings;
  }
}

@Riverpod(keepAlive: true)
SettingsDatasource settingsDatasource(Ref ref) =>
    SecureSettingsDatasource(ref.watch(secureStorageDatasourceProvider));

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(settingsDatasourceProvider));
