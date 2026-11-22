import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/update/presentation/notifiers/app_update_notifier.dart';
import '../../features/update/presentation/widgets/app_update_sheet.dart';
import '../testing/app_widget_keys.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/motion_widgets.dart';
import 'app_routes.dart';

/// Smooth Orisale v4 bottom dock with directional tab transitions & sliding pill.
class AppNavigationShell extends ConsumerStatefulWidget {
  const AppNavigationShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends ConsumerState<AppNavigationShell> {
  int _lastIndex = 0;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkStartupUpdate());
    });
  }

  Future<void> _checkStartupUpdate() async {
    final hasUpdate =
        await ref.read(appUpdateProvider.notifier).checkOnStartupIfNeeded();
    if (!mounted || !hasUpdate) return;
    final release = ref.read(appUpdateProvider).release;
    if (release == null) return;
    await AppUpdateSheet.show(context, isMandatory: release.isMandatory);
  }

  @override
  void didUpdateWidget(covariant AppNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextIndex = widget.navigationShell.currentIndex;
    if (nextIndex != _lastIndex) {
      _direction = nextIndex >= _lastIndex ? 1 : -1;
      _lastIndex = nextIndex;
    }
  }

  void _selectTab(int index) {
    final current = widget.navigationShell.currentIndex;
    if (index != current) {
      setState(() {
        _direction = index > current ? 1 : -1;
        _lastIndex = index;
      });
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == current,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final centerBg = isDark ? AppColors.darkPrimary : AppColors.lightCharcoal;
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey<int>(currentIndex),
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutExpo,
        builder: (context, t, child) {
          final dx = _direction * 28.0 * (1 - t);
          final scale = 0.985 + (0.015 * t);
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            ),
          );
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: AppSpacing.hairlineBorder,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const centerSlotWidth = 60.0;
                  final tabSlotWidth =
                      (constraints.maxWidth - centerSlotWidth) / 4;
                  const pillWidth = 52.0;
                  final pillLeft = switch (currentIndex) {
                    0 => (tabSlotWidth - pillWidth) / 2,
                    1 => tabSlotWidth + (tabSlotWidth - pillWidth) / 2,
                    2 =>
                      (tabSlotWidth * 2) +
                          centerSlotWidth +
                          (tabSlotWidth - pillWidth) / 2,
                    _ =>
                      (tabSlotWidth * 3) +
                          centerSlotWidth +
                          (tabSlotWidth - pillWidth) / 2,
                  };

                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 340),
                        curve: Curves.easeOutExpo,
                        left: pillLeft.clamp(0.0, constraints.maxWidth),
                        top: 7,
                        child: Container(
                          width: pillWidth,
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _DockNavItem(
                              key: AppWidgetKeys.navTabPresensi,
                              label: 'Beranda',
                              icon: Icons.home_outlined,
                              selectedIcon: Icons.home_rounded,
                              selected: currentIndex == 0,
                              onTap: () => _selectTab(0),
                            ),
                          ),
                          Expanded(
                            child: _DockNavItem(
                              key: AppWidgetKeys.navTabJurnal,
                              label: 'Jurnal',
                              icon: Icons.menu_book_outlined,
                              selectedIcon: Icons.menu_book_rounded,
                              selected: currentIndex == 1,
                              onTap: () => _selectTab(1),
                            ),
                          ),
                          SizedBox(
                            width: centerSlotWidth,
                            child: Center(
                              child: Tooltip(
                                message: 'Selfie Check-In',
                                child: BouncyTap(
                                  key: AppWidgetKeys.navCameraCenterButton,
                                  scaleDown: 0.88,
                                  hoverScale: 1.08,
                                  onTap: () => const AttendanceSelfieRoute()
                                      .push<void>(context),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: centerBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _DockNavItem(
                              key: AppWidgetKeys.navTabIzin,
                              label: 'Izin',
                              icon: Icons.event_note_outlined,
                              selectedIcon: Icons.event_note_rounded,
                              selected: currentIndex == 2,
                              onTap: () => _selectTab(2),
                            ),
                          ),
                          Expanded(
                            child: _DockNavItem(
                              key: AppWidgetKeys.navTabRiwayat,
                              label: 'Riwayat',
                              icon: Icons.bar_chart_outlined,
                              selectedIcon: Icons.bar_chart_rounded,
                              selected: currentIndex == 3,
                              onTap: () => _selectTab(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DockNavItem extends StatelessWidget {
  const _DockNavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color =
        selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return BouncyTap(
      onTap: onTap,
      scaleDown: 0.90,
      hoverScale: 1.04,
      child: SizedBox(
        height: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 28,
              child: Center(
                child: AnimatedScale(
                  scale: selected ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutExpo,
                  child: Icon(
                    selected ? selectedIcon : icon,
                    size: 21,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
