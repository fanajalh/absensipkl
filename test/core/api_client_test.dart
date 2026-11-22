import 'dart:convert';

import 'package:absensi_pkl/core/constants/storage_keys.dart';
import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/core/network/api_client.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:absensi_pkl/features/journal/data/datasources/remote_journal_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiClient & Remote datasources', () {
    test('injects Bearer token from SecureStorage and parses login response',
        () async {
      final storage = InMemorySecureStorageDatasource();
      String? capturedAuthHeader;

      final client = MockClient((request) async {
        capturedAuthHeader = request.headers['Authorization'];
        if (request.url.path.endsWith('/auth/login')) {
          return http.Response(
            jsonEncode({
              'token': 'jwt_live_123',
              'user': {
                'id': 'u-1',
                'name': 'Rafi Pratama',
                'email': 'rafi@smk.sch.id',
                'nisn': '0078451920',
                'className': 'XII RPL 2',
              },
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'journals': [
              {
                'id': 'j-1',
                'title': 'Integrasi API',
                'description': 'Menghubungkan endpoint jurnal siswa ke backend.',
                'status': 'APPROVED',
                'photoUrl': 'bukti_1.jpg',
              },
            ],
          }),
          200,
        );
      });

      final apiClient = ApiClient(
        client: client,
        storage: storage,
        baseUrl: 'http://localhost:4000/api/v1',
      );
      final authDs = RemoteAuthDatasource(apiClient);
      final session = await authDs.login(
        identifier: '0078451920',
        password: 'secret',
      );

      expect(session.accessToken, equals('jwt_live_123'));
      expect(session.student.fullName, equals('Rafi Pratama'));
      expect(capturedAuthHeader, isNull);

      await storage.write(
        StorageKeys.authSession,
        jsonEncode(session.toJson()),
      );

      final journalDs = RemoteJournalDatasource(apiClient);
      final journals = await journalDs.getEntries();

      expect(capturedAuthHeader, equals('Bearer jwt_live_123'));
      expect(journals.length, equals(1));
      expect(journals.first.photoUrl, equals('bukti_1.jpg'));
    });

    test('maps HTTP 401, 403 mock GPS, and 422 geofence errors to AppError',
        () async {
      final storage = InMemorySecureStorageDatasource();

      final client401 = MockClient(
        (_) async => http.Response(jsonEncode({'message': 'Invalid'}), 401),
      );
      final api401 = ApiClient(
        client: client401,
        storage: storage,
        baseUrl: 'http://localhost:4000/api/v1',
      );
      await expectLater(
        () => api401.get('/auth/me'),
        throwsA(isA<UnauthorizedError>()),
      );

      final client403 = MockClient(
        (_) async => http.Response(
          jsonEncode({'code': 'MOCK_GPS', 'message': 'Fake GPS detected'}),
          403,
        ),
      );
      final api403 = ApiClient(
        client: client403,
        storage: storage,
        baseUrl: 'http://localhost:4000/api/v1',
      );
      await expectLater(
        () => api403.post('/siswa/check-in', body: <String, dynamic>{}),
        throwsA(isA<MockLocationDetectedError>()),
      );

      final client422 = MockClient(
        (_) async => http.Response(
          jsonEncode({'distanceMeters': 250, 'radiusMeters': 100}),
          422,
        ),
      );
      final api422 = ApiClient(
        client: client422,
        storage: storage,
        baseUrl: 'http://localhost:4000/api/v1',
      );
      await expectLater(
        () => api422.post('/siswa/check-in', body: <String, dynamic>{}),
        throwsA(isA<OutOfGeofenceError>()),
      );
    });
  });
}
