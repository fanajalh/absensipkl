import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../errors/app_error.dart';

part 'camera_datasource.g.dart';

/// Immutable snapshot of a captured & compressed photo with base64 Data URI support.
@immutable
class CapturedSelfie {
  const CapturedSelfie({
    required this.fileName,
    required this.mimeType,
    required this.capturedAt,
    this.bytes,
  });

  final Uint8List? bytes;
  final String fileName;
  final String mimeType;
  final DateTime capturedAt;

  /// Base64 Data URI (`data:image/jpeg;base64,...`) ready for API persistence & Web rendering.
  String? get dataUrl {
    final raw = bytes;
    if (raw == null || raw.isEmpty) return null;
    final safeMime = mimeType.trim().isEmpty ? 'image/jpeg' : mimeType;
    return 'data:$safeMime;base64,${base64Encode(raw)}';
  }

  /// Value to store in DTO/API (`dataUrl` when bytes exist, otherwise `fileName`).
  String get storageValue => dataUrl ?? fileName;

  CapturedSelfie copyWith({
    Uint8List? bytes,
    String? fileName,
    String? mimeType,
    DateTime? capturedAt,
  }) {
    return CapturedSelfie(
      bytes: bytes ?? this.bytes,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }

  /// Reconstructs a [CapturedSelfie] from a saved `data:image/...;base64,...` string or filename.
  static CapturedSelfie? fromSavedValue(
    String? value, {
    String defaultPrefix = 'foto',
  }) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.startsWith('data:image/')) {
      try {
        final commaIdx = trimmed.indexOf(',');
        if (commaIdx > 0) {
          final header = trimmed.substring(5, commaIdx);
          final mime = header.split(';').first;
          final ext = mime.contains('png') ? 'png' : 'jpg';
          final decoded = base64Decode(trimmed.substring(commaIdx + 1));
          return CapturedSelfie(
            bytes: decoded,
            fileName: '$defaultPrefix.$ext',
            mimeType: mime,
            capturedAt: DateTime.now(),
          );
        }
      } catch (_) {}
    }
    return CapturedSelfie(
      fileName: trimmed,
      mimeType:
          trimmed.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg',
      capturedAt: DateTime.now(),
    );
  }
}

/// Camera & compressed documentation photo capture contract.
abstract interface class CameraDatasource {
  Future<CapturedSelfie?> captureSelfie();

  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false});
}

/// Platform implementation using [ImagePicker] with real file/camera bytes.
class ImagePickerCameraDatasource implements CameraDatasource {
  ImagePickerCameraDatasource({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;
  static const int _maxFileBytes = 5 * 1024 * 1024;
  static const Set<String> _allowedExtensions = <String>{
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
  };

  @override
  Future<CapturedSelfie?> captureSelfie() => _pickAndValidate(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        prefix: 'selfie',
      );

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      _pickAndValidate(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        prefix: 'foto',
      );

  Future<CapturedSelfie?> _pickAndValidate({
    required ImageSource source,
    required CameraDevice preferredCameraDevice,
    required String prefix,
  }) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        preferredCameraDevice: preferredCameraDevice,
        maxWidth: 1280,
        imageQuality: 78,
      );
      if (picked == null) return null;

      final lowerName = picked.name.toLowerCase();
      final hasValidExtension = _allowedExtensions.any(lowerName.endsWith);
      if (!kIsWeb && !hasValidExtension) {
        throw const AppError.validation(
          message: 'Format foto harus JPG, PNG, atau WEBP.',
        );
      }

      final bytes = await picked.readAsBytes();
      if (bytes.isEmpty || bytes.length > _maxFileBytes) {
        throw const AppError.validation(
          message: 'Ukuran foto melebihi 5 MB.',
        );
      }

      final safeName = picked.name.trim().isNotEmpty
          ? picked.name.trim()
          : '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      return CapturedSelfie(
        bytes: bytes,
        fileName: safeName,
        mimeType: lowerName.endsWith('.png') ? 'image/png' : 'image/jpeg',
        capturedAt: DateTime.now(),
      );
    } on AppError {
      rethrow;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Camera capture error: $error');
      }
      throw const AppError.cameraUnavailable(
        message: 'Kamera atau file tidak dapat diakses.',
      );
    }
  }
}

@Riverpod(keepAlive: true)
CameraDatasource cameraDatasource(Ref ref) => ImagePickerCameraDatasource();
