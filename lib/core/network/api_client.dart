import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../constants/storage_keys.dart';
import '../errors/app_error.dart';
import '../services/secure_storage_datasource.dart';

part 'api_client.g.dart';

/// Typed HTTP client with automatic Bearer token injection, timeout, and safe
/// mapping into [AppError] without leaking internal details.
class ApiClient {
  ApiClient({
    required http.Client client,
    required SecureStorageDatasource storage,
    String? baseUrl,
  })  : _client = client,
        _storage = storage,
        _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final http.Client _client;
  final SecureStorageDatasource _storage;
  final String _baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
  }) =>
      _send(method: 'GET', path: path, queryParams: queryParams);

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) =>
      _send(method: 'POST', path: path, body: body);

  Future<Map<String, dynamic>> _send({
    required String method,
    required String path,
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(path, queryParams);
    final token = await _readToken();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    late final http.Response response;
    try {
      final future = switch (method) {
        'POST' => _client.post(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          ),
        _ => _client.get(uri, headers: headers),
      };
      response = await future.timeout(AppConfig.networkTimeout);
    } on TimeoutException {
      throw const AppError.network(
        message: 'Koneksi ke server timeout. Periksa jaringan Anda.',
      );
    } on http.ClientException catch (error) {
      if (kDebugMode) {
        debugPrint('HTTP ClientException on $path: $error');
      }
      throw const AppError.network(
        message: 'Tidak dapat terhubung ke server.',
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Unexpected HTTP error on $path: $error');
      }
      throw const AppError.network(
        message: 'Gagal menghubungi server.',
      );
    }

    final payload = _decodeJsonMap(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return payload;
    }

    throw _mapHttpError(response.statusCode, payload);
  }

  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final normalizedBase =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath');
    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(queryParameters: queryParams);
  }

  Future<String?> _readToken() async {
    try {
      final raw = await _storage.read(StorageKeys.authSession);
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final token = decoded['accessToken'] as String?;
        if (token != null && token.isNotEmpty) return token;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Map<String, dynamic> _decodeJsonMap(String body) {
    if (body.trim().isEmpty) return const <String, dynamic>{};
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  AppError _mapHttpError(int statusCode, Map<String, dynamic> payload) {
    final serverMessage = _extractMessage(payload);
    final code = (payload['code'] as String?)?.toLowerCase() ?? '';
    final lowerMsg = (serverMessage ?? '').toLowerCase();

    if (statusCode == 401) {
      return AppError.unauthorized(
        message: serverMessage ?? 'Sesi berakhir atau kredensial salah.',
      );
    }

    if (statusCode == 403) {
      if (code.contains('mock') ||
          lowerMsg.contains('mock') ||
          lowerMsg.contains('fake')) {
        return AppError.mockLocationDetected(
          message: serverMessage ?? 'Lokasi palsu (Fake GPS) terdeteksi.',
        );
      }
      return AppError.validation(
        message: serverMessage ?? 'Akses ditolak.',
      );
    }

    if (statusCode == 422) {
      final distance = (payload['distanceMeters'] as num?)?.toDouble();
      final radius = (payload['radiusMeters'] as num?)?.toDouble();
      if (distance != null && radius != null) {
        return AppError.outOfGeofence(
          distanceMeters: distance,
          radiusMeters: radius,
        );
      }
      if (code.contains('geofence') ||
          lowerMsg.contains('radius') ||
          lowerMsg.contains('jarak')) {
        return AppError.outOfGeofence(
          distanceMeters: distance ?? 150,
          radiusMeters: radius ?? 100,
        );
      }
      return AppError.validation(
        message: serverMessage ?? 'Data pengajuan tidak valid.',
      );
    }

    if (statusCode >= 400 && statusCode < 500) {
      return AppError.validation(
        message: serverMessage ?? 'Permintaan tidak dapat diproses.',
      );
    }

    return const AppError.network(
      message: 'Server sedang gangguan. Coba sesaat lagi.',
    );
  }

  String? _extractMessage(Map<String, dynamic> payload) {
    final msg = payload['message'] ?? payload['error'];
    if (msg is String && msg.trim().isNotEmpty) return msg.trim();
    return null;
  }
}

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) => ApiClient(
      client: ref.watch(httpClientProvider),
      storage: ref.watch(secureStorageDatasourceProvider),
    );
