/// Metadata for an Android APK release published on GitHub Releases.
class AppRelease {
  const AppRelease({
    required this.tagName,
    required this.version,
    required this.changelog,
    required this.apkFileName,
    required this.apkDownloadUrl,
    required this.apkSizeBytes,
    required this.htmlUrl,
    required this.isMandatory,
    this.sha256Url,
    this.publishedAt,
  });

  final String tagName;
  final String version;
  final String changelog;
  final String apkFileName;
  final String apkDownloadUrl;
  final int apkSizeBytes;
  final String htmlUrl;
  final bool isMandatory;
  final String? sha256Url;
  final DateTime? publishedAt;

  /// Parses GitHub Releases `/releases/latest` JSON payload.
  /// Returns `null` if no `.apk` asset is attached.
  static AppRelease? fromGitHubJson(Map<String, dynamic> json) {
    final rawTag = (json['tag_name'] as String? ?? '').trim();
    if (rawTag.isEmpty) return null;

    final rawAssets = json['assets'];
    if (rawAssets is! List<dynamic>) return null;

    Map<String, dynamic>? apkAsset;
    Map<String, dynamic>? shaAsset;

    for (final item in rawAssets) {
      if (item is! Map<String, dynamic>) continue;
      final name = (item['name'] as String? ?? '').trim();
      final lower = name.toLowerCase();
      if (lower.endsWith('.apk') && apkAsset == null) {
        apkAsset = item;
      } else if (lower.contains('sha256') && lower.endsWith('.txt')) {
        shaAsset = item;
      }
    }

    if (apkAsset == null) return null;

    final downloadUrl =
        (apkAsset['browser_download_url'] as String? ?? '').trim();
    if (downloadUrl.isEmpty) return null;

    final rawBody = (json['body'] as String? ?? '').trim();
    final isMandatory = rawBody.toUpperCase().contains('[FORCE]');
    final cleanedBody = rawBody
        .replaceAll(RegExp(r'\[FORCE\]', caseSensitive: false), '')
        .trim();

    return AppRelease(
      tagName: rawTag,
      version: SemVer.normalize(rawTag),
      changelog: cleanedBody.isEmpty
          ? 'Pembaruan stabilitas dan peningkatan performa.'
          : cleanedBody,
      apkFileName: (apkAsset['name'] as String? ?? 'absensi-pkl.apk').trim(),
      apkDownloadUrl: downloadUrl,
      apkSizeBytes: (apkAsset['size'] as num?)?.toInt() ?? 0,
      htmlUrl: (json['html_url'] as String? ?? downloadUrl).trim(),
      isMandatory: isMandatory,
      sha256Url: (shaAsset?['browser_download_url'] as String?)?.trim(),
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
    );
  }
}

/// Pure Semantic Versioning comparator supporting `v1.2.3+4` tags.
abstract final class SemVer {
  static String normalize(String raw) {
    var clean = raw.trim();
    if (clean.startsWith('v') || clean.startsWith('V')) {
      clean = clean.substring(1);
    }
    final plusIndex = clean.indexOf('+');
    if (plusIndex != -1) {
      clean = clean.substring(0, plusIndex);
    }
    final dashIndex = clean.indexOf('-');
    if (dashIndex != -1) {
      clean = clean.substring(0, dashIndex);
    }
    return clean.trim();
  }

  static List<int> parseParts(String raw) {
    final clean = normalize(raw);
    if (clean.isEmpty) return const <int>[0, 0, 0];
    final segments = clean.split('.');
    return List<int>.generate(3, (index) {
      if (index >= segments.length) return 0;
      return int.tryParse(segments[index]) ?? 0;
    });
  }

  /// Returns `true` if [remoteVersion] is strictly newer than [currentVersion].
  static bool isNewer(String remoteVersion, String currentVersion) {
    final remote = parseParts(remoteVersion);
    final current = parseParts(currentVersion);
    for (var i = 0; i < 3; i++) {
      if (remote[i] != current[i]) {
        return remote[i] > current[i];
      }
    }
    return false;
  }

  /// Extracts expected 64-char hex SHA-256 digest for [fileName] from `SHA256SUMS.txt`.
  static String? parseSha256ForFile(String content, String fileName) {
    final lines = content.split(RegExp(r'\r?\n'));
    final lowerTarget = fileName.toLowerCase();
    String? firstHash;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final match = RegExp(r'^([a-fA-F0-9]{64})\s+\*?(.+)$').firstMatch(trimmed);
      if (match == null) continue;
      final hash = match.group(1)!.toLowerCase();
      final name = match.group(2)!.trim().toLowerCase();
      firstHash ??= hash;
      if (name == lowerTarget || name.endsWith('/$lowerTarget')) {
        return hash;
      }
    }
    return firstHash;
  }
}
