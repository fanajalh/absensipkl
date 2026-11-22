import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_media_attachment_field.dart';
import '../../domain/entities/journal_entry.dart';
import 'validation_status_badge.dart';

/// Pure UI clean white Orisale v4 card for a daily PKL journal entry.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final JournalEntry entry;
  final VoidCallback onTap;

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
    final rawPhoto = entry.photoUrl?.trim();
    final hasPhoto = rawPhoto != null && rawPhoto.isNotEmpty;
    final decodedBytes = _decodeDataUrl(rawPhoto);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
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
                  child: Text(
                    '${entry.date.toIndonesianShortDate()} (${entry.startTime} – ${entry.endTime})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ValidationStatusBadge(status: entry.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              entry.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              entry.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            if (hasPhoto) ...<Widget>[
              const SizedBox(height: AppSpacing.sm + 2),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => showAttachmentPreviewDialog(
                  context,
                  title: entry.title,
                  fileName: 'Foto Bukti',
                  bytes: decodedBytes,
                  sourceUrl: rawPhoto,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF4F8FC),
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
            if (entry.mentorNote != null &&
                entry.mentorNote!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              const Divider(
                height: AppSpacing.hairlineBorder,
                thickness: AppSpacing.hairlineBorder,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Pembimbing: ${entry.mentorNote}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
