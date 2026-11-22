import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'motion_widgets.dart';

/// Clean Orisale v4 pill back button for AppBar leading slot.
class AppHeaderBackButton extends StatelessWidget {
  const AppHeaderBackButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Align(
        alignment: Alignment.centerLeft,
        child: BouncyTap(
          onTap: onPressed,
          scaleDown: 0.92,
          hoverScale: 1.03,
          child: Container(
            height: 36,
            padding: const EdgeInsets.only(left: 7, right: 11),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: colorScheme.outline,
                width: AppSpacing.hairlineBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean Orisale v4 pill action button for AppBar actions and section headers.
class AppHeaderActionButton extends StatelessWidget {
  const AppHeaderActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isPrimary = false,
    this.onDarkCamera = false,
    this.trailingPadding = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isPrimary;
  final bool onDarkCamera;
  final bool trailingPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final disabled = onPressed == null && !isLoading;

    final Color bgColor;
    final Color fgColor;
    final Color borderColor;

    if (onDarkCamera) {
      bgColor = Colors.white.withValues(alpha: 0.12);
      fgColor = Colors.white;
      borderColor = Colors.white.withValues(alpha: 0.18);
    } else if (isPrimary) {
      bgColor = colorScheme.primary;
      fgColor = Colors.white;
      borderColor = Colors.transparent;
    } else {
      bgColor = isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;
      fgColor = colorScheme.primary;
      borderColor = colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.22);
    }

    final pill = Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: BouncyTap(
        onTap: isLoading ? null : onPressed,
        scaleDown: 0.92,
        hoverScale: 1.03,
        child: Container(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: icon != null ? 12 : 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(999),
            border: borderColor == Colors.transparent
                ? null
                : Border.all(
                    color: borderColor,
                    width: AppSpacing.hairlineBorder,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isLoading) ...<Widget>[
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fgColor,
                  ),
                ),
                const SizedBox(width: 6),
              ] else if (icon != null) ...<Widget>[
                Icon(icon, size: 15, color: fgColor),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: fgColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!trailingPadding) return pill;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Center(child: pill),
    );
  }
}
