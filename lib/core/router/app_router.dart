import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_state.dart';
import '../../features/settings/domain/entities/app_settings.dart';
import '../../features/settings/presentation/notifiers/settings_notifier.dart';
import 'app_routes.dart';
import 'redirect_resolver.dart';

part 'app_router.g.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();

  ref.listen<AuthState>(
    authProvider,
    (_, _) => refreshNotifier.refresh(),
  );
  ref.listen<AsyncValue<AppSettings>>(
    settingsProvider,
    (_, _) => refreshNotifier.refresh(),
  );

  final router = GoRouter(
    initialLocation: const PresensiRoute().location,
    routes: $appRoutes,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final settingsAsync = ref.read(settingsProvider);

      final isLoading = authState is AuthLoading || settingsAsync.isLoading;
      final hasSeenOnboarding =
          settingsAsync.asData?.value.onboardingSeen ?? false;
      final isAuthenticated = authState is AuthAuthenticated;

      return resolveAppRedirect(
        isLoading: isLoading,
        hasSeenOnboarding: hasSeenOnboarding,
        isAuthenticated: isAuthenticated,
        currentLocation: state.matchedLocation,
        onboardingLocation: const OnboardingRoute().location,
        loginLocation: const LoginRoute().location,
        homeLocation: const PresensiRoute().location,
      );
    },
  );

  ref.onDispose(() {
    refreshNotifier.dispose();
    router.dispose();
  });

  return router;
}
