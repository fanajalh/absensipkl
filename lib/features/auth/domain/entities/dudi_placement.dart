import 'package:freezed_annotation/freezed_annotation.dart';

part 'dudi_placement.freezed.dart';

/// Pure domain entity representing a student's assigned DUDI workplace.
@freezed
abstract class DudiPlacement with _$DudiPlacement {
  const factory DudiPlacement({
    required String id,
    required String companyName,
    required String address,
    required String mentorName,
    required double latitude,
    required double longitude,
    required double allowedRadiusMeters,
    required String workStartTime,
    required String workEndTime,
  }) = _DudiPlacement;
}
