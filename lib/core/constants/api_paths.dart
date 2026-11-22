/// Central API endpoints and default DUDI placement configuration constants.
abstract final class ApiPaths {
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String siswaHome = '/siswa/home';
  static const String checkIn = '/siswa/check-in';
  static const String checkOut = '/siswa/check-out';
  static const String journals = '/siswa/journals';
  static const String leaves = '/siswa/leaves';
  static const String history = '/siswa/history';

  // Default DUDI placement fallback constants
  static const double defaultDudiLatitude = -6.208763;
  static const double defaultDudiLongitude = 106.845599;
  static const double defaultAllowedRadiusMeters = 100.0;
  static const String defaultWorkStart = '08:00';
  static const String defaultWorkEnd = '17:00';
}
