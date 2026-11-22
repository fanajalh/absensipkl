import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// Sealed domain/application error union mapped to safe Indonesian user messages.
@freezed
sealed class AppError with _$AppError implements Exception {
  const factory AppError.network({required String message}) = NetworkError;

  const factory AppError.unauthorized({required String message}) =
      UnauthorizedError;

  const factory AppError.validation({required String message}) = ValidationError;

  const factory AppError.storage({required String message}) = StorageError;

  const factory AppError.locationDisabled({required String message}) =
      LocationDisabledError;

  const factory AppError.locationPermissionDenied({required String message}) =
      LocationPermissionDeniedError;

  const factory AppError.mockLocationDetected({required String message}) =
      MockLocationDetectedError;

  const factory AppError.outOfGeofence({
    required double distanceMeters,
    required double radiusMeters,
  }) = OutOfGeofenceError;

  const factory AppError.cameraUnavailable({required String message}) =
      CameraUnavailableError;

  const factory AppError.unexpected({required String message}) = UnexpectedError;
}

extension AppErrorMessage on AppError {
  String get userMessage => switch (this) {
        NetworkError(:final message) => message,
        UnauthorizedError(:final message) => message,
        ValidationError(:final message) => message,
        StorageError(:final message) => message,
        LocationDisabledError(:final message) => message,
        LocationPermissionDeniedError(:final message) => message,
        MockLocationDetectedError(:final message) => message,
        OutOfGeofenceError(:final distanceMeters, :final radiusMeters) =>
          'Anda berada di luar radius DUDI (${distanceMeters.round()} m dari batas ${radiusMeters.round()} m).',
        CameraUnavailableError(:final message) => message,
        UnexpectedError(:final message) => message,
      };
}

/// Maps arbitrary caught errors into typed [AppError] without leaking internals.
abstract final class AppErrorMapper {
  static AppError fromObject(Object error) {
    if (error is AppError) return error;
    if (error is FormatException) {
      return const AppError.storage(
        message: 'Data lokal tidak dapat dibaca. Silakan coba lagi.',
      );
    }
    return const AppError.unexpected(
      message: 'Terjadi kendala sistem. Silakan coba beberapa saat lagi.',
    );
  }
}
