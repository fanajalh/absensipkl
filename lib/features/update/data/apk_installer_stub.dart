typedef ApkDownloadProgress = void Function(
  int bytesReceived,
  int totalBytes,
);

/// Result of downloading an APK and checking its integrity.
class DownloadedApk {
  const DownloadedApk({
    required this.filePath,
    required this.sha256,
    required this.sizeBytes,
  });

  final String filePath;
  final String sha256;
  final int sizeBytes;
}

/// Web / non-Android stub implementation.
abstract final class ApkInstaller {
  static bool get isSupported => false;

  static Future<bool> canInstallPackages() async => false;

  static Future<void> openInstallPermissionSettings() async {}

  static Future<DownloadedApk> downloadApk({
    required String url,
    required String fileName,
    required ApkDownloadProgress onProgress,
    String? expectedSha256,
  }) {
    throw UnsupportedError(
      'Instalasi APK otomatis hanya tersedia di perangkat Android.',
    );
  }

  static Future<void> installApk(String filePath) {
    throw UnsupportedError(
      'Instalasi APK otomatis hanya tersedia di perangkat Android.',
    );
  }
}
