import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/app_config.dart';
import '../../data/apk_installer.dart';
import '../../data/github_release_datasource.dart';
import '../../domain/entities/app_release.dart';

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

enum AppUpdateStatus {
  idle,
  checking,
  upToDate,
  available,
  downloading,
  verifying,
  permissionRequired,
  readyToInstall,
  error,
}

class AppUpdateState {
  const AppUpdateState({
    this.currentVersion = '1.0.0',
    this.status = AppUpdateStatus.idle,
    this.release,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.downloadedFilePath,
    this.message,
  });

  final String currentVersion;
  final AppUpdateStatus status;
  final AppRelease? release;
  final int bytesReceived;
  final int totalBytes;
  final String? downloadedFilePath;
  final String? message;

  double get progress {
    if (totalBytes <= 0) return 0;
    return (bytesReceived / totalBytes).clamp(0.0, 1.0);
  }

  int get progressPercent => (progress * 100).round();

  bool get hasUpdate =>
      release != null &&
      (status == AppUpdateStatus.available ||
          status == AppUpdateStatus.downloading ||
          status == AppUpdateStatus.verifying ||
          status == AppUpdateStatus.permissionRequired ||
          status == AppUpdateStatus.readyToInstall);

  AppUpdateState copyWith({
    String? currentVersion,
    AppUpdateStatus? status,
    AppRelease? release,
    int? bytesReceived,
    int? totalBytes,
    String? downloadedFilePath,
    String? message,
    bool clearMessage = false,
  }) {
    return AppUpdateState(
      currentVersion: currentVersion ?? this.currentVersion,
      status: status ?? this.status,
      release: release ?? this.release,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

/// Provides the currently installed app version string (e.g. `1.0.0`).
final currentAppVersionProvider = Provider<Future<String> Function()>((ref) {
  return () async {
    if (_isWidgetTestBinding) return '1.0.0';
    try {
      final info = await PackageInfo.fromPlatform();
      return SemVer.normalize(info.version);
    } catch (_) {
      return '1.0.0';
    }
  };
});

class AppUpdateNotifier extends Notifier<AppUpdateState> {
  bool _hasAutoChecked = false;

  @override
  AppUpdateState build() => const AppUpdateState();

  /// Runs a silent startup check once per session (skipped in widget tests).
  Future<bool> checkOnStartupIfNeeded() async {
    if (_hasAutoChecked ||
        !AppConfig.autoCheckUpdates ||
        _isWidgetTestBinding) {
      return false;
    }
    _hasAutoChecked = true;
    return checkForUpdate(silent: true);
  }

  /// Checks GitHub Releases for a newer APK version. Returns `true` if available.
  Future<bool> checkForUpdate({bool silent = false}) async {
    final currentVersion = await ref.read(currentAppVersionProvider)();
    if (!silent) {
      state = state.copyWith(
        currentVersion: currentVersion,
        status: AppUpdateStatus.checking,
        clearMessage: true,
      );
    } else {
      state = state.copyWith(currentVersion: currentVersion);
    }

    try {
      final latest = await ref.read(releaseDatasourceProvider).fetchLatestRelease();
      if (latest == null || !SemVer.isNewer(latest.version, currentVersion)) {
        state = state.copyWith(
          currentVersion: currentVersion,
          status: AppUpdateStatus.upToDate,
          message: 'Aplikasi sudah versi terbaru (v$currentVersion).',
        );
        return false;
      }

      state = state.copyWith(
        currentVersion: currentVersion,
        status: AppUpdateStatus.available,
        release: latest,
        clearMessage: true,
      );
      return true;
    } catch (error) {
      if (silent) {
        return false;
      }
      state = state.copyWith(
        currentVersion: currentVersion,
        status: AppUpdateStatus.error,
        message: 'Tidak bisa memeriksa pembaruan sekarang. Cek koneksi internet.',
      );
      return false;
    }
  }

  /// Downloads APK with progress %, verifies SHA-256, and triggers Android installer.
  Future<void> startDownloadAndInstall() async {
    final release = state.release;
    if (release == null) return;

    if (!ApkInstaller.isSupported) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        message: 'Instalasi APK otomatis hanya berjalan di HP Android.',
      );
      return;
    }

    try {
      final canInstall = await ApkInstaller.canInstallPackages();
      if (!canInstall) {
        state = state.copyWith(
          status: AppUpdateStatus.permissionRequired,
          message:
              'Aktifkan izin "Install aplikasi dari sumber tidak dikenal" untuk melanjutkan.',
        );
        return;
      }

      state = state.copyWith(
        status: AppUpdateStatus.downloading,
        bytesReceived: 0,
        totalBytes: release.apkSizeBytes,
        clearMessage: true,
      );

      final expectedSha = await ref
          .read(releaseDatasourceProvider)
          .fetchExpectedSha256(release);

      final downloaded = await ApkInstaller.downloadApk(
        url: release.apkDownloadUrl,
        fileName: release.apkFileName,
        expectedSha256: expectedSha,
        onProgress: (received, total) {
          final effectiveTotal = total > 0 ? total : release.apkSizeBytes;
          state = state.copyWith(
            status: received >= effectiveTotal && effectiveTotal > 0
                ? AppUpdateStatus.verifying
                : AppUpdateStatus.downloading,
            bytesReceived: received,
            totalBytes: effectiveTotal,
          );
        },
      );

      state = state.copyWith(
        status: AppUpdateStatus.readyToInstall,
        downloadedFilePath: downloaded.filePath,
        bytesReceived: downloaded.sizeBytes,
        totalBytes: downloaded.sizeBytes,
        message: 'Verifikasi SHA-256 valid. Membuka installer Android...',
      );

      await ApkInstaller.installApk(downloaded.filePath);
    } catch (error) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        message: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> openInstallPermissionSettings() async {
    await ApkInstaller.openInstallPermissionSettings();
  }

  Future<void> retryInstall() async {
    final filePath = state.downloadedFilePath;
    if (filePath == null || filePath.isEmpty) {
      await startDownloadAndInstall();
      return;
    }
    try {
      final canInstall = await ApkInstaller.canInstallPackages();
      if (!canInstall) {
        state = state.copyWith(
          status: AppUpdateStatus.permissionRequired,
          message: 'Izin install APK belum aktif.',
        );
        return;
      }
      await ApkInstaller.installApk(filePath);
    } catch (error) {
      state = state.copyWith(
        status: AppUpdateStatus.error,
        message: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final appUpdateProvider =
    NotifierProvider<AppUpdateNotifier, AppUpdateState>(AppUpdateNotifier.new);
