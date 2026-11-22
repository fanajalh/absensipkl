import 'dart:math' as math;

/// Pure Dart Open Location Code (Google Plus Code) encoder for standard
/// Google Maps addresses (e.g. `H7J2+7GC, Jl. Gelora Indah I, Purwokerto...`).
abstract final class PlusCodeHelper {
  static const String _alphabet = '23456789CFGHJMPQRVWX';
  static const int _base = 20;
  static const int _gridCols = 4;
  static const int _gridRows = 5;

  static String encodeFull(double latitude, double longitude) {
    final cLat = latitude.clamp(-90.0, 90.0) + 90.0;
    var cLng = longitude + 180.0;
    while (cLng < 0) {
      cLng += 360.0;
    }
    while (cLng >= 360.0) {
      cLng -= 360.0;
    }

    var latVal =
        math.min((cLat * 8000 * 5).floor(), 180 * 8000 * 5 - 1);
    var lngVal =
        math.min((cLng * 8000 * 4).floor(), 360 * 8000 * 4 - 1);

    final rev = <String>[];
    final latGrid = latVal % _gridRows;
    final lngGrid = lngVal % _gridCols;
    rev.add(_alphabet[latGrid * _gridCols + lngGrid]);
    latVal ~/= _gridRows;
    lngVal ~/= _gridCols;

    for (var i = 0; i < 5; i++) {
      rev.add(_alphabet[lngVal % _base]);
      rev.add(_alphabet[latVal % _base]);
      latVal ~/= _base;
      lngVal ~/= _base;
    }

    final full = rev.reversed.join();
    return '${full.substring(0, 8)}+${full.substring(8)}';
  }

  static String encodeShort(double latitude, double longitude) {
    return encodeFull(latitude, longitude).substring(4);
  }

  static String formatStandardAddress({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    final shortCode = encodeShort(latitude, longitude);
    final trimmed = address.trim();
    if (trimmed.isEmpty) return shortCode;
    final hasPlusPrefix = RegExp(
      r'^[23456789CFGHJMPQRVWX]{4,8}\+[23456789CFGHJMPQRVWX]{2,3}',
      caseSensitive: false,
    ).hasMatch(trimmed);
    if (hasPlusPrefix) return trimmed;
    return '$shortCode, $trimmed';
  }
}
