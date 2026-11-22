import '../models/app_settings_dto.dart';

/// Persistence contract for app settings & onboarding completion flag.
abstract interface class SettingsDatasource {
  Future<AppSettingsDto> readSettings();

  Future<void> writeSettings(AppSettingsDto dto);
}
