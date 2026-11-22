// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsDto _$AppSettingsDtoFromJson(Map<String, dynamic> json) =>
    AppSettingsDto(
      onboardingSeen: json['onboardingSeen'] as bool? ?? false,
      checkInReminder: json['checkInReminder'] as bool? ?? true,
      journalReminder: json['journalReminder'] as bool? ?? true,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );

Map<String, dynamic> _$AppSettingsDtoToJson(AppSettingsDto instance) =>
    <String, dynamic>{
      'onboardingSeen': instance.onboardingSeen,
      'checkInReminder': instance.checkInReminder,
      'journalReminder': instance.journalReminder,
      'isDarkMode': instance.isDarkMode,
    };
