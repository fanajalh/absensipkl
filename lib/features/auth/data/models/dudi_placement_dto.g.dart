// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dudi_placement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DudiPlacementDto _$DudiPlacementDtoFromJson(Map<String, dynamic> json) =>
    DudiPlacementDto(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      mentorName: json['mentorName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      allowedRadiusMeters: (json['allowedRadiusMeters'] as num).toDouble(),
      workStartTime: json['workStartTime'] as String,
      workEndTime: json['workEndTime'] as String,
    );

Map<String, dynamic> _$DudiPlacementDtoToJson(DudiPlacementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'address': instance.address,
      'mentorName': instance.mentorName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'allowedRadiusMeters': instance.allowedRadiusMeters,
      'workStartTime': instance.workStartTime,
      'workEndTime': instance.workEndTime,
    };
