import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/attendance/domain/entities/location_reading.dart';
import '../errors/app_error.dart';

part 'location_datasource.g.dart';

/// Simulation presets available strictly in Web/Demo mode for geofence QA.
enum DemoLocationPreset {
  insideRadius('Dalam Radius (42 m)', 'Simulasi posisi valid di area DUDI'),
  outsideRadius(
    'Di Luar Radius (320 m)',
    'Simulasi posisi melebihi batas 100 m',
  ),
  mockGps('Simulasi Mock GPS', 'Simulasi perangkat memakai Fake GPS');

  const DemoLocationPreset(this.label, this.description);

  final String label;
  final String description;
}

/// Abstraction over GPS hardware & mock-location detection.
abstract interface class LocationDatasource {
  bool get isSimulationSupported;

  DemoLocationPreset get currentPreset;

  void setDemoPreset(DemoLocationPreset preset);

  Future<LocationReading> getCurrentLocation({
    required double targetLat,
    required double targetLng,
  });
}

/// Platform implementation wrapping [Geolocator] on mobile and deterministic
/// geofence presets on Web preview.
class GeolocatorLocationDatasource implements LocationDatasource {
  DemoLocationPreset _preset = DemoLocationPreset.insideRadius;

  @override
  bool get isSimulationSupported => kIsWeb;

  @override
  DemoLocationPreset get currentPreset => _preset;

  @override
  void setDemoPreset(DemoLocationPreset preset) {
    _preset = preset;
  }

  @override
  Future<LocationReading> getCurrentLocation({
    required double targetLat,
    required double targetLng,
  }) async {
    if (kIsWeb) {
      return _buildSimulatedReading(
        targetLat: targetLat,
        targetLng: targetLng,
      );
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const AppError.locationDisabled(
          message:
              'Layanan GPS perangkat tidak aktif. Aktifkan lokasi terlebih dahulu.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const AppError.locationPermissionDenied(
          message:
              'Izin lokasi ditolak. Berikan akses lokasi pada pengaturan aplikasi.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      return LocationReading(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
        isMocked: position.isMocked,
        recordedAt: DateTime.now(),
      );
    } on AppError {
      rethrow;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Geolocator error: $error');
      }
      throw const AppError.locationDisabled(
        message: 'Gagal membaca koordinat GPS. Pastikan sinyal lokasi stabil.',
      );
    }
  }

  LocationReading _buildSimulatedReading({
    required double targetLat,
    required double targetLng,
  }) {
    final now = DateTime.now();
    return switch (_preset) {
      DemoLocationPreset.insideRadius => LocationReading(
          latitude: targetLat + 0.00030,
          longitude: targetLng + 0.00023,
          accuracyMeters: 8.5,
          isMocked: false,
          recordedAt: now,
        ),
      DemoLocationPreset.outsideRadius => LocationReading(
          latitude: targetLat + 0.00240,
          longitude: targetLng + 0.00160,
          accuracyMeters: 12.0,
          isMocked: false,
          recordedAt: now,
        ),
      DemoLocationPreset.mockGps => LocationReading(
          latitude: targetLat + 0.00025,
          longitude: targetLng + 0.00020,
          accuracyMeters: 5.0,
          isMocked: true,
          recordedAt: now,
        ),
    };
  }
}

@Riverpod(keepAlive: true)
LocationDatasource locationDatasource(Ref ref) =>
    GeolocatorLocationDatasource();
