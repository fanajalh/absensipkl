import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

/// Native Android APK downloader, SHA-256 verifier, and FileProvider installer.
abstract final class ApkInstaller {
  static const MethodChannel _channel =
      MethodChannel('id.fanajalh.absensi_pkl/updater');

  static bool get isSupported => Platform.isAndroid;

  static Future<bool> canInstallPackages() async {
    if (!Platform.isAndroid) return false;
    final allowed = await _channel.invokeMethod<bool>('canInstallPackages');
    return allowed ?? false;
  }

  static Future<void> openInstallPermissionSettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('openInstallPermissionSettings');
  }

  static Future<Directory> _resolveReadableUpdatesDir() async {
    try {
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        final dir = Directory('${extDir.path}/updates');
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        return dir;
      }
    } catch (_) {
      // Fallback to temporary directory below
    }
    final cacheDir = await getTemporaryDirectory();
    final dir = Directory('${cacheDir.path}/updates');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<DownloadedApk> downloadApk({
    required String url,
    required String fileName,
    required ApkDownloadProgress onProgress,
    String? expectedSha256,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'Instalasi APK otomatis hanya tersedia di perangkat Android.',
      );
    }

    final updatesDir = await _resolveReadableUpdatesDir();
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final targetFile = File('${updatesDir.path}/$safeName');
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }

    final client = http.Client();
    IOSink? sink;
    try {
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = true
        ..maxRedirects = 8
        ..headers['User-Agent'] = 'AbsensiPKL-Android-Updater/1.0';
      final response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Gagal mengunduh APK (HTTP ${response.statusCode}).',
        );
      }

      final totalBytes = response.contentLength ?? 0;
      var receivedBytes = 0;
      List<int>? firstFourBytes;

      sink = targetFile.openWrite();
      final digestSink = _SingleDigestSink();
      final shaInput = sha256.startChunkedConversion(digestSink);

      await for (final chunk in response.stream) {
        if (firstFourBytes == null && chunk.length >= 4) {
          firstFourBytes = chunk.sublist(0, 4);
        }
        sink.add(chunk);
        shaInput.add(chunk);
        receivedBytes += chunk.length;
        onProgress(receivedBytes, totalBytes);
      }

      await sink.flush();
      await sink.close();
      sink = null;
      shaInput.close();

      // Validate ZIP/APK magic header (PK\x03\x04) and minimum realistic size
      final isValidZipHeader = firstFourBytes != null &&
          firstFourBytes.length >= 4 &&
          firstFourBytes[0] == 0x50 &&
          firstFourBytes[1] == 0x4B &&
          firstFourBytes[2] == 0x03 &&
          firstFourBytes[3] == 0x04;
      if (!isValidZipHeader || receivedBytes < 1024 * 1024) {
        if (targetFile.existsSync()) {
          await targetFile.delete();
        }
        throw const FormatException(
          'File unduhan bukan paket APK yang valid. Silakan coba lagi.',
        );
      }

      final digest = digestSink.value.toString().toLowerCase();

      if (expectedSha256 != null &&
          expectedSha256.isNotEmpty &&
          digest != expectedSha256.toLowerCase()) {
        if (targetFile.existsSync()) {
          await targetFile.delete();
        }
        throw const FormatException(
          'Verifikasi SHA-256 gagal. File APK mungkin korup, silakan ulangi.',
        );
      }

      return DownloadedApk(
        filePath: targetFile.path,
        sha256: digest,
        sizeBytes: receivedBytes,
      );
    } finally {
      await sink?.close();
      client.close();
    }
  }

  static Future<void> installApk(String filePath) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'Instalasi APK otomatis hanya tersedia di perangkat Android.',
      );
    }
    await _channel.invokeMethod<void>(
      'installApk',
      <String, dynamic>{'filePath': filePath},
    );
  }
}

class _SingleDigestSink implements Sink<Digest> {
  Digest? _value;

  Digest get value => _value!;

  @override
  void add(Digest data) => _value = data;

  @override
  void close() {}
}
