import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_media_attachment_field.dart';
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

  Uint8List? _decodeDataUrl(String? raw) {
    if (raw == null || !raw.startsWith('data:image/')) return null;
    final commaIdx = raw.indexOf(',');
    if (commaIdx <= 0) return null;
    try {
      return base64Decode(raw.substring(commaIdx + 1));
    } catch (_) {
      return null;
    }
  }

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

    final rawAttachment = request.attachmentName?.trim();
    final hasAttachment = rawAttachment != null && rawAttachment.isNotEmpty;
    final decodedBytes = _decodeDataUrl(rawAttachment);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              LeaveStatusPill(status: request.status),
            ],
          ),
          if (hasAttachment) ...<Widget>[
            const SizedBox(height: AppSpacing.sm + 2),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => showAttachmentPreviewDialog(
                context,
                title: 'Lampiran ${request.type.label}',
                fileName: 'Lampiran',
                bytes: decodedBytes,
                sourceUrl: rawAttachment,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outline,
                    width: AppSpacing.hairlineBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (decodedBytes != null) ...<Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.memory(
                          decodedBytes,
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ] else ...<Widget>[
                      Icon(
                        Icons.photo_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      'Lihat Foto',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
