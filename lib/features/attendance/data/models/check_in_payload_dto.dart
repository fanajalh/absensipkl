import 'package:json_annotation/json_annotation.dart';

part 'check_in_payload_dto.g.dart';

@JsonSerializable()
class CheckInPayloadDto {
  const CheckInPayloadDto({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.distanceMeters,
    required this.isMocked,
    required this.selfieLabel,
    required this.capturedAtIso,
  });

  factory CheckInPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$CheckInPayloadDtoFromJson(json);

  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final double distanceMeters;
  final bool isMocked;
  final String selfieLabel;
  final String capturedAtIso;

  Map<String, dynamic> toJson() => _$CheckInPayloadDtoToJson(this);
}
