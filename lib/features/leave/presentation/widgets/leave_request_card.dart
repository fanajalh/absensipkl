import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_request.dart';
import 'leave_status_pill.dart';

/// Pure UI Orisale v4 card summarizing a submitted leave/sick request.
class LeaveRequestCard extends StatelessWidget {
  const LeaveRequestCard({
    super.key,
    required this.request,
    this.highlight = false,
  });

  final LeaveRequest request;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final dateText = request.startDate.isSameCalendarDay(request.endDate)
        ? request.startDate.toIndonesianShortDate()
        : '${request.startDate.toIndonesianShortDate()} – ${request.endDate.toIndonesianShortDate()}';

    final useSoftSky =
        highlight || request.status == LeaveApprovalStatus.approved;
    final cardBg = useSoftSky
        ? (isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft)
        : colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: useSoftSky
            ? null
            : Border.all(
                color: colorScheme.outline,
                width: AppSpacing.hairlineBorder,
              ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  request.reason,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${request.type.label} $dateText (${request.totalDays} hari)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
                if (request.attachmentName != null &&
                    request.attachmentName!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_file_rounded,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          request.attachmentName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          LeaveStatusPill(status: request.status),
        ],
      ),
    );
  }
}
