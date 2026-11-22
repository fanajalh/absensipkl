import 'dart:convert';

import 'package:absensi_pkl/core/constants/storage_keys.dart';
import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/features/auth/data/datasources/demo_auth_datasource.dart';
import 'package:absensi_pkl/features/auth/data/models/auth_session_dto.dart';
import 'package:absensi_pkl/features/auth/data/models/dudi_placement_dto.dart';
import 'package:absensi_pkl/features/auth/data/models/student_profile_dto.dart';
import 'package:absensi_pkl/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:absensi_pkl/features/auth/presentation/notifiers/auth_state.dart';
import 'package:absensi_pkl/features/auth/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthNotifier', () {
    test('restores unauthenticated state when secure storage is empty',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
          authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        ],
      );

      await container.read(authProvider.notifier).restoreSession();

      expect(
        container.read(authProvider),
        equals(const AuthState.unauthenticated()),
      );
    });

    test('login succeeds with valid credentials and persists session',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
          authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        ],
      );

      await container.read(authProvider.notifier).login(
            identifier: DemoAuthDatasource.demoNisn,
            password: DemoAuthDatasource.demoPasscode,
          );

      final state = container.read(authProvider);
      expect(state, isA<AuthAuthenticated>());
      final authenticated = state as AuthAuthenticated;
      expect(authenticated.session.student.nisn, equals('0078451920'));
      expect(
        authenticated.session.student.placement.companyName,
        equals('PT Fanajalh Digital Indonesia'),
      );

      final persistedRaw = await storage.read(StorageKeys.authSession);
      expect(persistedRaw, isNotEmpty);
      final decoded = jsonDecode(persistedRaw!) as Map<String, dynamic>;
      expect(decoded['accessToken'], startsWith('demo_session_'));
    });

    test('login fails with invalid credentials and surfaces UnauthorizedError',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
          authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        ],
      );

      await container.read(authProvider.notifier).login(
            identifier: DemoAuthDatasource.demoNisn,
            password: 'wrong-password',
          );

      final state = container.read(authProvider);
      expect(state, isA<AuthUnauthenticated>());
      final unauthenticated = state as AuthUnauthenticated;
      expect(unauthenticated.error, isA<UnauthorizedError>());
      expect(
        unauthenticated.error?.userMessage,
        equals('NISN/Email atau kata sandi tidak sesuai.'),
      );
      expect(await storage.read(StorageKeys.authSession), isNull);
    });

    test('logout clears state and removes persisted session from storage',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
          authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        ],
      );

      await container.read(authProvider.notifier).login(
            identifier: DemoAuthDatasource.demoEmail,
            password: DemoAuthDatasource.demoPasscode,
          );
      expect(container.read(authProvider), isA<AuthAuthenticated>());

      await container.read(authProvider.notifier).logout();

      expect(
        container.read(authProvider),
        equals(const AuthState.unauthenticated()),
      );
      expect(await storage.read(StorageKeys.authSession), isNull);
    });

    test('restores persisted non-expired session and clears expired session',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final now = DateTime.now();
      final validDto = _buildSessionDto(
        issuedAt: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(days: 1)),
      );
      await storage.write(
        StorageKeys.authSession,
        jsonEncode(validDto.toJson()),
      );

      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
          authDatasourceProvider.overrideWithValue(DemoAuthDatasource()),
        ],
      );

      await container.read(authProvider.notifier).restoreSession();
      expect(container.read(authProvider), isA<AuthAuthenticated>());

      final expiredDto = _buildSessionDto(
        issuedAt: now.subtract(const Duration(days: 8)),
        expiresAt: now.subtract(const Duration(minutes: 1)),
      );
      await storage.write(
        StorageKeys.authSession,
        jsonEncode(expiredDto.toJson()),
      );

      await container.read(authProvider.notifier).restoreSession();
      expect(
        container.read(authProvider),
        equals(const AuthState.unauthenticated()),
      );
      expect(await storage.read(StorageKeys.authSession), isNull);
    });
  });
}

AuthSessionDto _buildSessionDto({
  required DateTime issuedAt,
  required DateTime expiresAt,
}) {
  return AuthSessionDto(
    accessToken: 'tok-test-001',
    issuedAtIso: issuedAt.toIso8601String(),
    expiresAtIso: expiresAt.toIso8601String(),
    student: const StudentProfileDto(
      id: 'std-1',
      nisn: DemoAuthDatasource.demoNisn,
      fullName: 'Rafi Pratama Putra',
      className: 'XII RPL 2',
      major: 'Rekayasa Perangkat Lunak',
      email: DemoAuthDatasource.demoEmail,
      placement: DudiPlacementDto(
        id: 'dudi-1',
        companyName: 'PT Fanajalh Digital Indonesia',
        address: 'Jakarta Selatan',
        mentorName: 'Budi Santoso, S.Kom.',
        latitude: -6.208763,
        longitude: 106.845599,
        allowedRadiusMeters: 100.0,
        workStartTime: '08:00',
        workEndTime: '17:00',
      ),
    ),
  );
}
