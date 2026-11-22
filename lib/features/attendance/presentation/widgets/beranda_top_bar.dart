import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Concise Orisale v4 top bar for Beranda with avatar, announcements & map.
class BerandaTopBar extends StatelessWidget {
  const BerandaTopBar({
    super.key,
    required this.isRefreshing,
    required this.hasAnnouncements,
    required this.onAvatarTap,
    required this.onAnnouncementsTap,
    required this.onRefreshTap,
    required this.onMapTap,
  });

  final bool isRefreshing;
  final bool hasAnnouncements;
  final VoidCallback onAvatarTap;
  final VoidCallback onAnnouncementsTap;
  final VoidCallback onRefreshTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final avatarBg =
        isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;

    return Row(
      children: <Widget>[
        GestureDetector(
          key: AppWidgetKeys.profileAvatarButton,
          behavior: HitTestBehavior.opaque,
          onTap: onAvatarTap,
          child: Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: avatarBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline,
                width: AppSpacing.hairlineBorder,
              ),
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/illustrations/avatar_rafi.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Absensi PKL',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        IconButton(
          key: AppWidgetKeys.announcementsButton,
          tooltip: 'Pengumuman',
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: EdgeInsets.zero,
          onPressed: onAnnouncementsTap,
          icon: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Icon(
                Icons.notifications_none_rounded,
                size: 22,
                color: colorScheme.onSurface,
              ),
              if (hasAnnouncements)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.lightYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          key: AppWidgetKeys.refreshLocationButton,
          tooltip: 'Perbarui lokasi',
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: EdgeInsets.zero,
          onPressed: isRefreshing ? null : onRefreshTap,
          icon: isRefreshing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: colorScheme.onSurface,
                ),
        ),
        IconButton(
          key: AppWidgetKeys.mapShortcutButton,
          tooltip: 'Peta DUDI',
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: EdgeInsets.zero,
          onPressed: onMapTap,
          icon: Icon(
            Icons.location_on_outlined,
            size: 21,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
