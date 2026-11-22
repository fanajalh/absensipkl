import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/geofence_evaluation.dart';

/// Pure UI dual Orisale v4 KPI cards (White Check-In/Clock + Sky-Blue Radius).
class BerandaKpiRow extends StatelessWidget {
  const BerandaKpiRow({
    super.key,
    required this.currentTime,
    required this.todayRecord,
    required this.geofence,
    required this.isBusy,
    required this.onCheckActionTap,
    required this.onMapTap,
  });

  final DateTime currentTime;
  final AttendanceRecord? todayRecord;
  final GeofenceEvaluation? geofence;
  final bool isBusy;
  final VoidCallback onCheckActionTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasIn = todayRecord?.hasCheckedIn ?? false;
    final hasOut = todayRecord?.hasCheckedOut ?? false;
    final isDone = hasIn && hasOut;

    final (String leftPill, String actionLabel) = switch ((hasIn, hasOut)) {
      (true, true) => ('Selesai', 'Selesai'),
      (true, false) => ('Aktif', 'Check-Out'),
      _ => ('Hari 42', 'Check-In'),
    };

    final (String radiusPill, String distanceText, Color blueCardBg) =
        _resolveRadiusVisuals(geofence, isDark);

    return Row(
      children: <Widget>[
        Expanded(
          child: BouncyTap(
            key: AppWidgetKeys.checkActionButton,
            onTap: (isBusy || isDone) ? null : onCheckActionTap,
            child: Container(
              height: 158,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl - 2),
                border: Border.all(
                  color: colorScheme.outline,
                  width: AppSpacing.hairlineBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.lightYellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm + 2,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              leftPill,
                              maxLines: 1,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                fontFeatures: const <FontFeature>[
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              currentTime.toTimeHms(),
                              key: AppWidgetKeys.liveClockText,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                fontFeatures: const <FontFeature>[
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'WIB',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              isBusy ? 'Memproses...' : actionLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: BouncyTap(
            onTap: onMapTap,
            child: Container(
              height: 158,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: blueCardBg,
                gradient: blueCardBg == AppColors.lightPrimary
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFF29AAFF), Color(0xFF1594F5)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl - 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: blueCardBg,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm + 2,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.24),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (radiusPill == 'Valid') ...<Widget>[
                                  const LivePulseDot(
                                    color: Colors.white,
                                    size: 6,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  radiusPill,
                                  maxLines: 1,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (geofence != null)
                        AnimatedCountText(
                          value: geofence!.distanceMeters.round(),
                          suffix: ' m',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            fontFeatures: const <FontFeature>[
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        )
                      else
                        Text(
                          distanceText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            fontFeatures: const <FontFeature>[
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Radius DUDI',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  (String, String, Color) _resolveRadiusVisuals(
    GeofenceEvaluation? current,
    bool isDark,
  ) {
    final defaultBlue =
        isDark ? const Color(0xFF1565A6) : AppColors.lightPrimary;
    if (current == null) {
      return ('Menunggu', '-- m', defaultBlue);
    }
    if (current.isMocked) {
      return (
        'Fake GPS',
        '${current.distanceMeters.round()} m',
        AppColors.rose,
      );
    }
    if (!current.isWithinRadius) {
      return (
        'Di Luar',
        '${current.distanceMeters.round()} m',
        AppColors.rose,
      );
    }
    return ('Valid', '${current.distanceMeters.round()} m', defaultBlue);
  }
}
