// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInPayloadDto _$CheckInPayloadDtoFromJson(Map<String, dynamic> json) =>
    CheckInPayloadDto(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracyMeters: (json['accuracyMeters'] as num).toDouble(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      isMocked: json['isMocked'] as bool,
      selfieLabel: json['selfieLabel'] as String,
      capturedAtIso: json['capturedAtIso'] as String,
    );

Map<String, dynamic> _$CheckInPayloadDtoToJson(CheckInPayloadDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracyMeters': instance.accuracyMeters,
      'distanceMeters': instance.distanceMeters,
      'isMocked': instance.isMocked,
      'selfieLabel': instance.selfieLabel,
      'capturedAtIso': instance.capturedAtIso,
    };
