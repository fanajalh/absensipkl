/// Compile-time environment configuration for API, updates & offline demo mode.
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000/api/v1',
  );

  static const bool useDemoMode = bool.fromEnvironment(
    'DEMO_MODE',
    defaultValue: false,
  );

  /// GitHub repository (`owner/repo`) used for checking APK releases.
  /// Automatically injected during CI builds via `--dart-define=GITHUB_REPO=...`.
  static const String githubRepo = String.fromEnvironment(
    'GITHUB_REPO',
    defaultValue: 'fanajalh/absensipkl',
  );

  static const bool autoCheckUpdates = bool.fromEnvironment(
    'AUTO_CHECK_UPDATES',
    defaultValue: true,
  );

  static const Duration networkTimeout = Duration(seconds: 10);
}
