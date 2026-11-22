import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_splash_overlay.dart';
import 'features/settings/presentation/notifiers/settings_notifier.dart';

/// Root application widget wiring Riverpod, typed GoRouter, and Settings theme.
class AbsensiPklApp extends ConsumerWidget {
  const AbsensiPklApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDarkMode = ref.watch(
      settingsProvider.select((s) => s.asData?.value.isDarkMode ?? false),
    );

    return MaterialApp.router(
      title: 'Absensi Digital PKL',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _SmoothAppScrollBehavior(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) => AppSplashOverlay(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _SmoothAppScrollBehavior extends MaterialScrollBehavior {
  const _SmoothAppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      );
}
