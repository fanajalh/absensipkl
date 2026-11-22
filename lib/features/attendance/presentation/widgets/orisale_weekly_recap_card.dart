import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';

/// Pure UI Orisale v4 Weekly Recap chart container (`#EAF4FF`) + white card.
class OrisaleWeeklyRecapCard extends StatelessWidget {
  const OrisaleWeeklyRecapCard({
    super.key,
    required this.attendedDays,
    required this.targetDays,
    required this.approvedJournals,
    required this.onTap,
  });

  final int attendedDays;
  final int targetDays;
  final int approvedJournals;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final containerBg =
        isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;
    final activeBar =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final mutedBar =
        isDark ? AppColors.darkPrimaryBarMuted : AppColors.lightPrimaryBarMuted;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 82,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _BarColumn(
                  label: 'M1',
                  height: 58,
                  delayMs: 40,
                  color: activeBar,
                  textColor: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                _BarColumn(
                  label: 'M2',
                  height: 48,
                  delayMs: 100,
                  color: mutedBar,
                  textColor: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                _BarColumn(
                  label: 'M3',
                  height: 44,
                  delayMs: 160,
                  color: mutedBar,
                  textColor: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                _BarColumn(
                  label: 'M4',
                  height: 36,
                  delayMs: 220,
                  color: mutedBar,
                  textColor: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          BouncyTap(
            onTap: onTap,
            scaleDown: 0.97,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md + 2,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.lightYellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _RecapStat(
                            value: attendedDays,
                            suffix: '/$targetDays',
                            label: 'Hari PKL',
                          ),
                        ),
                        Expanded(
                          child: _RecapStat(
                            value: approvedJournals,
                            label: 'Jurnal ACC',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.label,
    required this.height,
    required this.delayMs,
    required this.color,
    required this.textColor,
  });

  final String label;
  final double height;
  final int delayMs;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 420 + delayMs),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Container(
              height: (height * value).clamp(4.0, height),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapStat extends StatelessWidget {
  const _RecapStat({
    required this.value,
    this.suffix = '',
    required this.label,
  });

  final int value;
  final String suffix;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedCountText(
          value: value,
          suffix: suffix,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
