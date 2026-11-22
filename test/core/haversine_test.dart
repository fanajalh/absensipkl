import 'package:absensi_pkl/core/constants/api_paths.dart';
import 'package:absensi_pkl/core/services/haversine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('haversineDistanceMeters', () {
    const dudiLat = ApiPaths.defaultDudiLatitude;
    const dudiLng = ApiPaths.defaultDudiLongitude;

    test('returns ~0 meters when start and end coordinates are identical', () {
      final distance = haversineDistanceMeters(
        startLat: dudiLat,
        startLng: dudiLng,
        endLat: dudiLat,
        endLng: dudiLng,
      );

      expect(distance, closeTo(0.0, 0.001));
    });

    test('computes ~42 meters within default 100m geofence radius', () {
      final distance = haversineDistanceMeters(
        startLat: dudiLat + 0.00030,
        startLng: dudiLng + 0.00023,
        endLat: dudiLat,
        endLng: dudiLng,
      );

      expect(distance, closeTo(41.9, 2.0));
      expect(distance, lessThanOrEqualTo(ApiPaths.defaultAllowedRadiusMeters));
    });

    test('computes >100 meters when coordinate is outside DUDI radius', () {
      final distance = haversineDistanceMeters(
        startLat: dudiLat + 0.00240,
        startLng: dudiLng + 0.00160,
        endLat: dudiLat,
        endLng: dudiLng,
      );

      expect(distance, closeTo(320.0, 15.0));
      expect(distance, greaterThan(ApiPaths.defaultAllowedRadiusMeters));
    });

    test('is symmetric regardless of start/end coordinate order', () {
      const targetLat = dudiLat + 0.001;
      const targetLng = dudiLng - 0.001;

      final forward = haversineDistanceMeters(
        startLat: dudiLat,
        startLng: dudiLng,
        endLat: targetLat,
        endLng: targetLng,
      );
      final reverse = haversineDistanceMeters(
        startLat: targetLat,
        startLng: targetLng,
        endLat: dudiLat,
        endLng: dudiLng,
      );

      expect(forward, closeTo(reverse, 1e-9));
    });
  });
}
