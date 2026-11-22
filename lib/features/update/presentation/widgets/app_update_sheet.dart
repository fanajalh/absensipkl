import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/apk_installer.dart';
import '../notifiers/app_update_notifier.dart';

/// Clean Orisale v4 bottom sheet for GitHub Releases APK auto-update.
class AppUpdateSheet extends ConsumerWidget {
  const AppUpdateSheet({super.key});

  static Future<void> show(BuildContext context, {bool isMandatory = false}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: !isMandatory,
      enableDrag: !isMandatory,
      showDragHandle: !isMandatory,
      builder: (_) => const AppUpdateSheet(),
    );
  }

  String _formatMb(int bytes) {
    if (bytes <= 0) return '0.0 MB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(appUpdateProvider);
    final release = update.release;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final isMandatory = release?.isMandatory ?? false;
    final isDownloading = update.status == AppUpdateStatus.downloading ||
        update.status == AppUpdateStatus.verifying;

    return PopScope(
      canPop: !isMandatory && !isDownloading,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSoft
                        : AppColors.lightSurfaceSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.system_update_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        release != null
                            ? 'Pembaruan Tersedia'
                            : 'Status Aplikasi',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        release != null
                            ? 'v${update.currentVersion} → v${release.version}'
                            : 'Versi saat ini v${update.currentVersion}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const <FontFeature>[
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMandatory)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.roseSoftDark
                          : AppColors.roseSoftLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Wajib',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.rose,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (release != null)
              Container(
                constraints: const BoxConstraints(maxHeight: 160),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    release.changelog,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                ),
              ),
            if (isDownloading) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    update.status == AppUpdateStatus.verifying
                        ? 'Memverifikasi SHA-256...'
                        : 'Mengunduh APK...',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${update.progressPercent}% (${_formatMb(update.bytesReceived)} / ${_formatMb(update.totalBytes)})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 7,
                  value: update.status == AppUpdateStatus.verifying
                      ? null
                      : update.progress,
                  backgroundColor: colorScheme.secondaryContainer,
                  color: colorScheme.primary,
                ),
              ),
            ],
            if (update.message != null) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: update.status == AppUpdateStatus.error
                      ? (isDark
                          ? AppColors.roseSoftDark
                          : AppColors.roseSoftLight)
                      : (isDark
                          ? AppColors.darkSurfaceSoft
                          : AppColors.lightSurfaceSoft),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Text(
                  update.message!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: update.status == AppUpdateStatus.error
                        ? AppColors.rose
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (release != null &&
                update.status == AppUpdateStatus.permissionRequired)
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(appUpdateProvider.notifier)
                      .openInstallPermissionSettings();
                },
                child: const Text('Buka Izin Install APK'),
              )
            else if (release != null &&
                update.status == AppUpdateStatus.readyToInstall)
              FilledButton(
                onPressed: () =>
                    ref.read(appUpdateProvider.notifier).retryInstall(),
                child: const Text('Pasang Pembaruan Sekarang'),
              )
            else if (release != null && ApkInstaller.isSupported)
              FilledButton(
                onPressed: isDownloading
                    ? null
                    : () => ref
                        .read(appUpdateProvider.notifier)
                        .startDownloadAndInstall(),
                child: Text(
                  isDownloading
                      ? 'Mengunduh ${update.progressPercent}%'
                      : 'Update Sekarang (${_formatMb(release.apkSizeBytes)})',
                ),
              )
            else if (release != null)
              FilledButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: release.apkDownloadUrl),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link download APK disalin ke clipboard.'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Salin Link APK GitHub'),
              )
            else
              FilledButton(
                onPressed: update.status == AppUpdateStatus.checking
                    ? null
                    : () => ref.read(appUpdateProvider.notifier).checkForUpdate(),
                child: Text(
                  update.status == AppUpdateStatus.checking
                      ? 'Memeriksa...'
                      : 'Cek Ulang',
                ),
              ),
            if (!isMandatory && !isDownloading) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Nanti Saja'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
