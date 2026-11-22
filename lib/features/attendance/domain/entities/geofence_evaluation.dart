import 'package:freezed_annotation/freezed_annotation.dart';

import 'location_reading.dart';

part 'geofence_evaluation.freezed.dart';

/// Result of evaluating a [LocationReading] against DUDI coordinates and radius.
@freezed
abstract class GeofenceEvaluation with _$GeofenceEvaluation {
  const GeofenceEvaluation._();

  const factory GeofenceEvaluation({
    required double distanceMeters,
    required double allowedRadiusMeters,
    required bool isWithinRadius,
    required bool isMocked,
    required DateTime evaluatedAt,
    required LocationReading location,
  }) = _GeofenceEvaluation;

  bool get canSubmitAttendance => isWithinRadius && !isMocked;
}
