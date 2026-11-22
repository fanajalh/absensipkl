import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/dudi_placement.dart';

part 'dudi_placement_dto.g.dart';

@JsonSerializable()
class DudiPlacementDto {
  const DudiPlacementDto({
    required this.id,
    required this.companyName,
    required this.address,
    required this.mentorName,
    required this.latitude,
    required this.longitude,
    required this.allowedRadiusMeters,
    required this.workStartTime,
    required this.workEndTime,
  });

  factory DudiPlacementDto.fromJson(Map<String, dynamic> json) =>
      _$DudiPlacementDtoFromJson(json);

  factory DudiPlacementDto.fromEntity(DudiPlacement entity) => DudiPlacementDto(
        id: entity.id,
        companyName: entity.companyName,
        address: entity.address,
        mentorName: entity.mentorName,
        latitude: entity.latitude,
        longitude: entity.longitude,
        allowedRadiusMeters: entity.allowedRadiusMeters,
        workStartTime: entity.workStartTime,
        workEndTime: entity.workEndTime,
      );

  final String id;
  final String companyName;
  final String address;
  final String mentorName;
  final double latitude;
  final double longitude;
  final double allowedRadiusMeters;
  final String workStartTime;
  final String workEndTime;

  Map<String, dynamic> toJson() => _$DudiPlacementDtoToJson(this);

  DudiPlacement toEntity() => DudiPlacement(
        id: id,
        companyName: companyName,
        address: address,
        mentorName: mentorName,
        latitude: latitude,
        longitude: longitude,
        allowedRadiusMeters: allowedRadiusMeters,
        workStartTime: workStartTime,
        workEndTime: workEndTime,
      );
}
