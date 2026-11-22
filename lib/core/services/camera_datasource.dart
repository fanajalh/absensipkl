import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../errors/app_error.dart';

part 'camera_datasource.g.dart';

/// Immutable snapshot of a captured & compressed photo.
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
}

/// Camera & compressed documentation photo capture contract.
abstract interface class CameraDatasource {
  Future<CapturedSelfie?> captureSelfie();

  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false});
}

/// Platform implementation using [ImagePicker] with mandatory compression
/// (`maxWidth: 1080, imageQuality: 70`) and Web-safe deterministic adapter.
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
        webPrefix: 'selfie',
      );

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) =>
      _pickAndValidate(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        webPrefix: 'jurnal',
      );

  Future<CapturedSelfie?> _pickAndValidate({
    required ImageSource source,
    required CameraDevice preferredCameraDevice,
    required String webPrefix,
  }) async {
    if (kIsWeb) {
      final now = DateTime.now();
      return CapturedSelfie(
        fileName: '${webPrefix}_${now.millisecondsSinceEpoch}.jpg',
        mimeType: 'image/jpeg',
        capturedAt: now,
      );
    }

    try {
      final picked = await _picker.pickImage(
        source: source,
        preferredCameraDevice: preferredCameraDevice,
        maxWidth: 1080,
        imageQuality: 70,
      );
      if (picked == null) return null;

      final lowerName = picked.name.toLowerCase();
      final hasValidExtension = _allowedExtensions.any(lowerName.endsWith);
      if (!hasValidExtension) {
        throw const AppError.validation(
          message: 'Format foto harus JPG, PNG, atau WEBP.',
        );
      }

      final bytes = await picked.readAsBytes();
      if (bytes.isEmpty || bytes.length > _maxFileBytes) {
        throw const AppError.validation(
          message: 'Ukuran foto tidak valid atau melebihi 5 MB.',
        );
      }

      return CapturedSelfie(
        bytes: bytes,
        fileName: picked.name,
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
        message: 'Kamera tidak tersedia atau izin ditolak.',
      );
    }
  }
}

@Riverpod(keepAlive: true)
CameraDatasource cameraDatasource(Ref ref) => ImagePickerCameraDatasource();
