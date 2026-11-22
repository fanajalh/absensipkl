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

    final cacheDir = await getTemporaryDirectory();
    final updatesDir = Directory('${cacheDir.path}/updates');
    if (!updatesDir.existsSync()) {
      await updatesDir.create(recursive: true);
    }

    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final targetFile = File('${updatesDir.path}/$safeName');
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }

    final client = http.Client();
    IOSink? sink;
    try {
      final request = http.Request('GET', Uri.parse(url))
        ..headers['Accept'] = 'application/octet-stream';
      final response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Gagal mengunduh APK (HTTP ${response.statusCode}).',
        );
      }

      final totalBytes = response.contentLength ?? 0;
      var receivedBytes = 0;

      sink = targetFile.openWrite();
      final digestSink = _SingleDigestSink();
      final shaInput = sha256.startChunkedConversion(digestSink);

      await for (final chunk in response.stream) {
        sink.add(chunk);
        shaInput.add(chunk);
        receivedBytes += chunk.length;
        onProgress(receivedBytes, totalBytes);
      }

      await sink.flush();
      await sink.close();
      sink = null;
      shaInput.close();

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
