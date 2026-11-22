import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Pure domain settings entity (no Flutter ThemeMode dependency).
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(false) bool onboardingSeen,
    @Default(true) bool checkInReminder,
    @Default(true) bool journalReminder,
    @Default(false) bool isDarkMode,
  }) = _AppSettings;
}
