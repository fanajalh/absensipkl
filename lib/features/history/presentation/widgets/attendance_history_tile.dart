import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/domain/entities/attendance_status.dart';

/// Polished Orisale v4 history row with tinted status icon & crisp badge.
class AttendanceHistoryTile extends StatelessWidget {
  const AttendanceHistoryTile({
    super.key,
    required this.record,
    required this.onTap,
  });

  final AttendanceRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final (IconData icon, Color accent, Color bg) = switch (record.status) {
      AttendanceStatus.present => (
          Icons.check_circle_rounded,
          isDark ? const Color(0xFF34D399) : AppColors.emerald,
          isDark ? AppColors.emeraldSoftDark : AppColors.emeraldSoftLight,
        ),
      AttendanceStatus.late => (
          Icons.schedule_rounded,
          isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
          isDark ? AppColors.amberSoftDark : AppColors.amberSoftLight,
        ),
      AttendanceStatus.leave => (
          Icons.event_available_rounded,
          colorScheme.primary,
          colorScheme.primaryContainer,
        ),
      AttendanceStatus.absent => (
          Icons.cancel_rounded,
          isDark ? const Color(0xFFF87171) : AppColors.rose,
          isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight,
        ),
    };

    final distanceTag = record.checkInDistanceMeters != null
        ? ' (${record.checkInDistanceMeters!.round()} m)'
        : '';
    final timeSummary = record.checkInTime != null
        ? '${record.checkInTime!.toTimeHm()} – ${record.checkOutTime?.toTimeHm() ?? '--:--'}$distanceTag'
        : (record.notes ?? 'Tanpa catatan');

    return BouncyTap(
      onTap: onTap,
      scaleDown: 0.985,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 19, color: accent),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    record.date.toIndonesianFullDate(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeSummary,
                    maxLines: 1,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                record.status.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
