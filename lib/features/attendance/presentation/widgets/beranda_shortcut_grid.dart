import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';

/// Compact 4-button quick shortcut row on Beranda (Selfie, Peta, Jurnal, Izin).
class BerandaShortcutGrid extends StatelessWidget {
  const BerandaShortcutGrid({
    super.key,
    required this.onSelfieTap,
    required this.onMapTap,
    required this.onJournalTap,
    required this.onLeaveTap,
  });

  final VoidCallback onSelfieTap;
  final VoidCallback onMapTap;
  final VoidCallback onJournalTap;
  final VoidCallback onLeaveTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final bg = isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;

    return Row(
      children: <Widget>[
        Expanded(
          child: _ShortcutTile(
            label: 'Selfie',
            icon: Icons.camera_alt_rounded,
            accent: accent,
            bg: bg,
            onTap: onSelfieTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: _ShortcutTile(
            label: 'Peta',
            icon: Icons.location_on_rounded,
            accent: accent,
            bg: bg,
            onTap: onMapTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: _ShortcutTile(
            label: 'Jurnal',
            icon: Icons.edit_note_rounded,
            accent: accent,
            bg: bg,
            onTap: onJournalTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: _ShortcutTile(
            label: 'Izin',
            icon: Icons.event_available_rounded,
            accent: accent,
            bg: bg,
            onTap: onLeaveTap,
          ),
        ),
      ],
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.label,
    required this.icon,
    required this.accent,
    required this.bg,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BouncyTap(
      onTap: onTap,
      scaleDown: 0.93,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md - 2,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline,
            width: AppSpacing.hairlineBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 21, color: accent),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
