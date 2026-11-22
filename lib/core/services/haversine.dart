import 'dart:math' as math;

/// Computes great-circle distance between two WGS-84 coordinates in meters
/// using the Haversine formula. Pure Dart with zero platform dependencies.
double haversineDistanceMeters({
  required double startLat,
  required double startLng,
  required double endLat,
  required double endLng,
}) {
  const earthRadiusMeters = 6371000.0;

  final dLat = _toRadians(endLat - startLat);
  final dLng = _toRadians(endLng - startLng);
  final lat1 = _toRadians(startLat);
  final lat2 = _toRadians(endLat);

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusMeters * c;
}

double _toRadians(double degrees) => degrees * math.pi / 180.0;
