import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/update/presentation/notifiers/app_update_notifier.dart';
import '../../features/update/presentation/widgets/app_update_sheet.dart';
import '../testing/app_widget_keys.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_routes.dart';

/// Clean floating bottom navbar where only the active tab expands into a
/// dark obsidian pill with icon + label while inactive tabs stay icon-only.
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
    unawaited(HapticFeedback.selectionClick());
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
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = widget.navigationShell.currentIndex;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final barBg = isDark ? const Color(0xFF151A25) : Colors.white;
    final barBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE6ECF4);

    return Scaffold(
      body: TweenAnimationBuilder<double>(
        key: ValueKey<int>(currentIndex),
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) {
          final dx = _direction * 16.0 * (1 - t);
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            ),
          );
        },
        child: widget.navigationShell,
      ),
      bottomNavigationBar: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            6,
            14,
            (bottomInset > 0 ? bottomInset : 12),
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: barBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: barBorder, width: 1),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.34 : 0.06,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _ExpandingNavPill(
                      key: AppWidgetKeys.navTabPresensi,
                      label: 'Beranda',
                      icon: Icons.home_outlined,
                      selected: currentIndex == 0,
                      onTap: () => _selectTab(0),
                    ),
                    _ExpandingNavPill(
                      key: AppWidgetKeys.navTabJurnal,
                      label: 'Jurnal',
                      icon: Icons.menu_book_outlined,
                      selected: currentIndex == 1,
                      onTap: () => _selectTab(1),
                    ),
                    _ExpandingNavPill(
                      key: AppWidgetKeys.navCameraCenterButton,
                      label: 'Absen',
                      icon: Icons.camera_alt_outlined,
                      selected: false,
                      onTap: () {
                        unawaited(HapticFeedback.lightImpact());
                        unawaited(
                          const AttendanceSelfieRoute().push<void>(context),
                        );
                      },
                    ),
                    _ExpandingNavPill(
                      key: AppWidgetKeys.navTabIzin,
                      label: 'Izin',
                      icon: Icons.event_note_outlined,
                      selected: currentIndex == 2,
                      onTap: () => _selectTab(2),
                    ),
                    _ExpandingNavPill(
                      key: AppWidgetKeys.navTabRiwayat,
                      label: 'Riwayat',
                      icon: Icons.bar_chart_outlined,
                      selected: currentIndex == 3,
                      onTap: () => _selectTab(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandingNavPill extends StatelessWidget {
  const _ExpandingNavPill({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inactiveIconColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        height: 44,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 11,
        ),
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 21,
              color: selected ? Colors.white : inactiveIconColor,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
