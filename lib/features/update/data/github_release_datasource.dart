import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../domain/entities/app_release.dart';

/// Fetches latest Android APK release metadata from GitHub Releases API.
abstract interface class ReleaseDatasource {
  Future<AppRelease?> fetchLatestRelease();
  Future<String?> fetchExpectedSha256(AppRelease release);
}

class GitHubReleaseDatasource implements ReleaseDatasource {
  GitHubReleaseDatasource({
    http.Client? client,
    String? repository,
  })  : _client = client ?? http.Client(),
        _repository = (repository ?? AppConfig.githubRepo).trim();

  final http.Client _client;
  final String _repository;

  @override
  Future<AppRelease?> fetchLatestRelease() async {
    if (_repository.isEmpty || !_repository.contains('/')) {
      return null;
    }

    final uri = Uri.https(
      'api.github.com',
      '/repos/$_repository/releases/latest',
    );
    final response = await _client.get(
      uri,
      headers: const <String, String>{
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    ).timeout(AppConfig.networkTimeout);

    if (response.statusCode == 404) {
      return null;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengecek pembaruan GitHub (HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;
    return AppRelease.fromGitHubJson(decoded);
  }

  @override
  Future<String?> fetchExpectedSha256(AppRelease release) async {
    final shaUrl = release.sha256Url;
    if (shaUrl == null || shaUrl.isEmpty) return null;

    final response = await _client
        .get(Uri.parse(shaUrl))
        .timeout(AppConfig.networkTimeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }
    return SemVer.parseSha256ForFile(response.body, release.apkFileName);
  }
}

final releaseDatasourceProvider = Provider<ReleaseDatasource>(
  (ref) => GitHubReleaseDatasource(),
);
