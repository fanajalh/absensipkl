import 'dart:convert';

import 'package:absensi_pkl/features/update/data/github_release_datasource.dart';
import 'package:absensi_pkl/features/update/domain/entities/app_release.dart';
import 'package:absensi_pkl/features/update/presentation/notifiers/app_update_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _FakeReleaseDatasource implements ReleaseDatasource {
  _FakeReleaseDatasource({this.release, this.shouldThrow = false});

  final AppRelease? release;
  final bool shouldThrow;

  @override
  Future<AppRelease?> fetchLatestRelease() async {
    if (shouldThrow) throw Exception('Network down');
    return release;
  }

  @override
  Future<String?> fetchExpectedSha256(AppRelease release) async => null;
}

void main() {
  group('SemVer & AppRelease parsing', () {
    test('compares semantic versions accurately across digits and prefixes', () {
      expect(SemVer.isNewer('v1.0.1', '1.0.0'), isTrue);
      expect(SemVer.isNewer('v1.10.0', '1.2.9'), isTrue);
      expect(SemVer.isNewer('2.0.0+12', '1.9.9+99'), isTrue);
      expect(SemVer.isNewer('v1.0.0', '1.0.0'), isFalse);
      expect(SemVer.isNewer('v0.9.9', '1.0.0'), isFalse);
    });

    test('parses GitHub release JSON, APK asset, SHA256SUMS, and [FORCE]', () {
      final release = AppRelease.fromGitHubJson(<String, dynamic>{
        'tag_name': 'v1.2.0',
        'body': '[FORCE]\nPerbaikan anti-fake GPS dan peta Google Maps.',
        'html_url': 'https://github.com/fanajalh/absensi-pkl/releases/tag/v1.2.0',
        'published_at': '2026-11-21T12:00:00Z',
        'assets': <Map<String, dynamic>>[
          <String, dynamic>{
            'name': 'absensi-pkl-v1.2.0.apk',
            'size': 24500000,
            'browser_download_url':
                'https://github.com/fanajalh/absensi-pkl/releases/download/v1.2.0/absensi-pkl-v1.2.0.apk',
          },
          <String, dynamic>{
            'name': 'SHA256SUMS.txt',
            'size': 96,
            'browser_download_url':
                'https://github.com/fanajalh/absensi-pkl/releases/download/v1.2.0/SHA256SUMS.txt',
          },
        ],
      });

      expect(release, isNotNull);
      expect(release!.version, '1.2.0');
      expect(release.isMandatory, isTrue);
      expect(release.changelog, 'Perbaikan anti-fake GPS dan peta Google Maps.');
      expect(release.apkFileName, 'absensi-pkl-v1.2.0.apk');
      expect(release.sha256Url, endsWith('SHA256SUMS.txt'));
    });

    test('extracts matching SHA-256 digest from SHA256SUMS.txt', () {
      const hash =
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
      final parsed = SemVer.parseSha256ForFile(
        '$hash  absensi-pkl-v1.2.0.apk\n',
        'absensi-pkl-v1.2.0.apk',
      );
      expect(parsed, hash);
    });

    test('GitHubReleaseDatasource parses mocked HTTP 200 latest release', () async {
      final mockClient = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://api.github.com/repos/fanajalh/absensi-pkl/releases/latest',
        );
        return http.Response(
          jsonEncode(<String, dynamic>{
            'tag_name': 'v1.1.0',
            'body': 'Rilis terbaru.',
            'html_url': 'https://github.com/fanajalh/absensi-pkl/releases/tag/v1.1.0',
            'assets': <Map<String, dynamic>>[
              <String, dynamic>{
                'name': 'absensi-pkl-v1.1.0.apk',
                'size': 21000000,
                'browser_download_url': 'https://example.com/app.apk',
              },
            ],
          }),
          200,
        );
      });

      final ds = GitHubReleaseDatasource(
        client: mockClient,
        repository: 'fanajalh/absensi-pkl',
      );
      final latest = await ds.fetchLatestRelease();
      expect(latest?.version, '1.1.0');
    });
  });

  group('AppUpdateNotifier', () {
    test('transitions to available when remote version is newer', () async {
      const newer = AppRelease(
        tagName: 'v1.2.0',
        version: '1.2.0',
        changelog: 'Update peta asli',
        apkFileName: 'absensi-pkl-v1.2.0.apk',
        apkDownloadUrl: 'https://example.com/v1.2.0.apk',
        apkSizeBytes: 22000000,
        htmlUrl: 'https://example.com/release',
        isMandatory: false,
      );

      final container = ProviderContainer(
        overrides: [
          releaseDatasourceProvider
              .overrideWithValue(_FakeReleaseDatasource(release: newer)),
          currentAppVersionProvider.overrideWithValue(() async => '1.0.0'),
        ],
      );
      addTearDown(container.dispose);

      final found =
          await container.read(appUpdateProvider.notifier).checkForUpdate();
      final state = container.read(appUpdateProvider);

      expect(found, isTrue);
      expect(state.status, AppUpdateStatus.available);
      expect(state.release?.version, '1.2.0');
    });

    test('transitions to upToDate when installed version matches latest', () async {
      const same = AppRelease(
        tagName: 'v1.0.0',
        version: '1.0.0',
        changelog: 'Initial release',
        apkFileName: 'absensi-pkl-v1.0.0.apk',
        apkDownloadUrl: 'https://example.com/v1.0.0.apk',
        apkSizeBytes: 20000000,
        htmlUrl: 'https://example.com/release',
        isMandatory: false,
      );

      final container = ProviderContainer(
        overrides: [
          releaseDatasourceProvider
              .overrideWithValue(_FakeReleaseDatasource(release: same)),
          currentAppVersionProvider.overrideWithValue(() async => '1.0.0'),
        ],
      );
      addTearDown(container.dispose);

      final found =
          await container.read(appUpdateProvider.notifier).checkForUpdate();
      final state = container.read(appUpdateProvider);

      expect(found, isFalse);
      expect(state.status, AppUpdateStatus.upToDate);
    });

    test('transitions to error on non-silent network failure', () async {
      final container = ProviderContainer(
        overrides: [
          releaseDatasourceProvider
              .overrideWithValue(_FakeReleaseDatasource(shouldThrow: true)),
          currentAppVersionProvider.overrideWithValue(() async => '1.0.0'),
        ],
      );
      addTearDown(container.dispose);

      final found =
          await container.read(appUpdateProvider.notifier).checkForUpdate();
      final state = container.read(appUpdateProvider);

      expect(found, isFalse);
      expect(state.status, AppUpdateStatus.error);
      expect(state.message, isNotNull);
    });
  });
}
