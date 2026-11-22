import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Pure UI single white rounded surface containing rows separated by hairline
/// dividers (no nested cards).
class IosInsetGroupedList extends StatelessWidget {
  const IosInsetGroupedList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: colorScheme.outline,
          width: AppSpacing.hairlineBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _interleaveDividers(children),
        ),
      ),
    );
  }

  static List<Widget> _interleaveDividers(List<Widget> items) {
    if (items.length <= 1) return items;
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(
          const Padding(
            padding: EdgeInsets.only(left: AppSpacing.lg),
            child: Divider(
              height: AppSpacing.hairlineBorder,
              thickness: AppSpacing.hairlineBorder,
            ),
          ),
        );
      }
    }
    return result;
  }
}

/// Pure UI tappable row with >= 48pt hit area for inset-grouped lists.
class IosGroupedActionRow extends StatelessWidget {
  const IosGroupedActionRow({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailingColor,
    this.showChevron = false,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? trailingText;
  final Color? trailingColor;
  final bool showChevron;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 28),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ] else ...<Widget>[
              if (trailingText != null) ...<Widget>[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  trailingText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trailingColor ?? colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (showChevron) ...<Widget>[
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ],
        ),
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}
