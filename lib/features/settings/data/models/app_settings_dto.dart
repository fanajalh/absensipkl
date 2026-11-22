import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/app_settings.dart';

part 'app_settings_dto.g.dart';

@JsonSerializable()
class AppSettingsDto {
  const AppSettingsDto({
    this.onboardingSeen = false,
    this.checkInReminder = true,
    this.journalReminder = true,
    this.isDarkMode = false,
  });

  factory AppSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsDtoFromJson(json);

  factory AppSettingsDto.fromEntity(AppSettings entity) => AppSettingsDto(
        onboardingSeen: entity.onboardingSeen,
        checkInReminder: entity.checkInReminder,
        journalReminder: entity.journalReminder,
        isDarkMode: entity.isDarkMode,
      );

  final bool onboardingSeen;
  final bool checkInReminder;
  final bool journalReminder;
  final bool isDarkMode;

  Map<String, dynamic> toJson() => _$AppSettingsDtoToJson(this);

  AppSettings toEntity() => AppSettings(
        onboardingSeen: onboardingSeen,
        checkInReminder: checkInReminder,
        journalReminder: journalReminder,
        isDarkMode: isDarkMode,
      );
}
