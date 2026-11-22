import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/location_datasource.dart';
import '../../../../core/services/plus_code_helper.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_header_buttons.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../notifiers/attendance_notifier.dart';
import '../notifiers/attendance_state.dart';
import '../widgets/attendance_feedback_banner.dart';
import '../widgets/geofence_demo_sheet.dart';
import '../widgets/geofence_vector_map.dart';

/// Concise Apple Maps-style geofence screen with debug-only QA simulation.
class AttendanceMapScreen extends ConsumerWidget {
  const AttendanceMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final student = switch (authState) {
      AuthAuthenticated(:final session) => session.student,
      _ => null,
    };

    if (student == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final dashboard =
        ref.watch(attendanceProvider).asData?.value ??
            const AttendanceDashboardState();
    final evaluation = dashboard.geofence;
    final placement = dashboard.placement ?? student.placement;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final hasIn = dashboard.todayRecord?.hasCheckedIn ?? false;
    final hasOut = dashboard.todayRecord?.hasCheckedOut ?? false;
    final isDone = hasIn && hasOut;

    final (String statusTitle, String badgeText, Color accent, Color bgColor) =
        _resolveSummary(evaluation, isDark);

    final standardAddress = PlusCodeHelper.formatStandardAddress(
      latitude: placement.latitude,
      longitude: placement.longitude,
      address: placement.address,
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 118,
        leading: AppHeaderBackButton(
          label: 'Beranda',
          onPressed: () => context.pop(),
        ),
        title: const Text('Lokasi Presensi'),
        actions: <Widget>[
          AppHeaderActionButton(
            key: AppWidgetKeys.refreshLocationButton,
            label: dashboard.isRefreshingLocation ? 'Memuat' : 'Perbarui',
            icon: Icons.refresh_rounded,
            isLoading: dashboard.isRefreshingLocation,
            onPressed: dashboard.isRefreshingLocation
                ? null
                : () =>
                    ref.read(attendanceProvider.notifier).refreshLocation(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (dashboard.actionError != null) ...<Widget>[
                    AttendanceFeedbackBanner(
                      message: dashboard.actionError!.userMessage,
                      isError: true,
                      onDismiss: () =>
                          ref.read(attendanceProvider.notifier).clearBanner(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        GeofenceVectorMap(
                          companyName: placement.companyName,
                          companyLatitude: placement.latitude,
                          companyLongitude: placement.longitude,
                          evaluation: evaluation,
                          allowedRadiusMeters: placement.allowedRadiusMeters,
                        ),
                        if (kDebugMode && dashboard.supportsDemoPreset)
                          Positioned(
                            right: AppSpacing.md,
                            bottom: AppSpacing.md,
                            child: FilledButton.tonalIcon(
                              key: AppWidgetKeys.geofenceTestSheetButton,
                              onPressed: dashboard.isRefreshingLocation
                                  ? null
                                  : () => _openDemoSheet(
                                        context,
                                        ref,
                                        dashboard,
                                      ),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.surface,
                                foregroundColor: colorScheme.primary,
                                minimumSize: const Size(44, 44),
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(Icons.tune_rounded, size: 16),
                              label: Text(dashboard.demoPreset.label),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    statusTitle,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$standardAddress (Batas ${placement.allowedRadiusMeters.round()} m)',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontFeatures: const <FontFeature>[
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs + 2,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                badgeText,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : accent,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: const <FontFeature>[
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          key: AppWidgetKeys.mapContinueSelfieButton,
                          onPressed: (dashboard.isRefreshingLocation || isDone)
                              ? null
                              : () => _continueToSelfie(context, ref),
                          child: Text(
                            isDone
                                ? 'Selesai'
                                : hasIn
                                    ? 'Lanjut Selfie Pulang'
                                    : 'Lanjut Selfie',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  (String, String, Color, Color) _resolveSummary(
    dynamic evaluation,
    bool isDark,
  ) {
    if (evaluation == null) {
      return (
        'Menunggu GPS',
        'Menunggu',
        AppColors.amber,
        isDark ? AppColors.amberSoftDark : AppColors.amberSoftLight,
      );
    }
    if (evaluation.isMocked as bool) {
      return (
        'Mock GPS Terdeteksi',
        'Diblokir',
        AppColors.rose,
        isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight,
      );
    }
    final dist = (evaluation.distanceMeters as double).round();
    if (!(evaluation.isWithinRadius as bool)) {
      return (
        'Di Luar Area DUDI',
        '$dist m Luar',
        AppColors.rose,
        isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight,
      );
    }
    return (
      'Dalam Area DUDI',
      '$dist m Valid',
      AppColors.emerald,
      isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoftLight,
    );
  }

  Future<void> _continueToSelfie(BuildContext context, WidgetRef ref) async {
    final evaluation = await ref
        .read(attendanceProvider.notifier)
        .validateGeofenceForSelfie();
    if (!context.mounted || evaluation == null) return;
    await const AttendanceSelfieRoute().push<void>(context);
  }

  Future<void> _openDemoSheet(
    BuildContext context,
    WidgetRef ref,
    AttendanceDashboardState dashboard,
  ) async {
    final selectedPreset = await showModalBottomSheet<DemoLocationPreset>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => GeofenceDemoSheet(
        options: <GeofenceDemoOption>[
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetInside,
            title: DemoLocationPreset.insideRadius.label,
            subtitle: DemoLocationPreset.insideRadius.description,
            isSelected:
                dashboard.demoPreset == DemoLocationPreset.insideRadius,
            onTap: () => Navigator.of(sheetContext)
                .pop(DemoLocationPreset.insideRadius),
          ),
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetOutside,
            title: DemoLocationPreset.outsideRadius.label,
            subtitle: DemoLocationPreset.outsideRadius.description,
            isSelected:
                dashboard.demoPreset == DemoLocationPreset.outsideRadius,
            onTap: () => Navigator.of(sheetContext)
                .pop(DemoLocationPreset.outsideRadius),
          ),
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetMock,
            title: DemoLocationPreset.mockGps.label,
            subtitle: DemoLocationPreset.mockGps.description,
            isSelected: dashboard.demoPreset == DemoLocationPreset.mockGps,
            onTap: () =>
                Navigator.of(sheetContext).pop(DemoLocationPreset.mockGps),
          ),
        ],
      ),
    );
    if (!context.mounted || selectedPreset == null) return;
    await ref.read(attendanceProvider.notifier).setDemoPreset(selectedPreset);
  }
}
