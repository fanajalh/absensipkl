import '../entities/app_settings.dart';

/// Contract for persisting onboarding & user preference flags.
abstract interface class SettingsRepository {
  Future<AppSettings> loadSettings();

  Future<AppSettings> saveSettings(AppSettings settings);
}
