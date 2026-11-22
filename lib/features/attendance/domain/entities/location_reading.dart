import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_reading.freezed.dart';

/// Pure domain snapshot of a GPS reading including anti-fake-GPS telemetry.
@freezed
abstract class LocationReading with _$LocationReading {
  const factory LocationReading({
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required bool isMocked,
    required DateTime recordedAt,
  }) = _LocationReading;
}
