import 'package:flutter/material.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_character.dart';
import '../../domain/entities/announcement.dart';

/// Concise bottom sheet listing announcements from `/siswa/home`.
class AnnouncementsSheet extends StatelessWidget {
  const AnnouncementsSheet({
    super.key,
    required this.announcements,
  });

  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
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
            Text(
              'Pengumuman',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (announcements.isEmpty)
              const AppEmptyCharacter(
                message: 'Belum ada pengumuman.',
                assetPath: 'assets/illustrations/undraw_onboarding.svg',
                imageHeight: 92,
              )
            else
              for (var i = 0; i < announcements.length; i++) ...<Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              announcements[i].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            announcements[i].createdAt.toIndonesianShortDate(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontFeatures: const <FontFeature>[
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        announcements[i].content,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < announcements.length - 1)
                  const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }
}
