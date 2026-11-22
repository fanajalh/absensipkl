import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppErrorMapper & AppErrorMessage', () {
    test('preserves existing AppError instances unchanged', () {
      const original = AppError.unauthorized(message: 'Sesi berakhir.');

      final mapped = AppErrorMapper.fromObject(original);

      expect(mapped, equals(original));
      expect(mapped.userMessage, equals('Sesi berakhir.'));
    });

    test('maps FormatException to StorageError with safe Indonesian message',
        () {
      const exception = FormatException('Unexpected character at 0');

      final mapped = AppErrorMapper.fromObject(exception);

      expect(mapped, isA<StorageError>());
      expect(
        mapped.userMessage,
        equals('Data lokal tidak dapat dibaca. Silakan coba lagi.'),
      );
      expect(mapped.userMessage, isNot(contains('Unexpected character')));
    });

    test('maps unknown errors to UnexpectedError without leaking internals',
        () {
      final rawError = StateError('SQLITE_CONSTRAINT secret_table');

      final mapped = AppErrorMapper.fromObject(rawError);

      expect(mapped, isA<UnexpectedError>());
      expect(
        mapped.userMessage,
        equals('Terjadi kendala sistem. Silakan coba beberapa saat lagi.'),
      );
      expect(mapped.userMessage, isNot(contains('SQLITE_CONSTRAINT')));
    });

    test('formats OutOfGeofenceError message with rounded meters', () {
      const error = AppError.outOfGeofence(
        distanceMeters: 319.6,
        radiusMeters: 100.0,
      );

      expect(
        error.userMessage,
        equals(
          'Anda berada di luar radius DUDI (320 m dari batas 100 m).',
        ),
      );
    });
  });
}
