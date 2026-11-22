import 'package:absensi_pkl/core/router/redirect_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveAppRedirect', () {
    const onboardingLocation = '/onboarding';
    const loginLocation = '/login';
    const homeLocation = '/';

    test('returns null while auth or settings state is loading', () {
      final result = resolveAppRedirect(
        isLoading: true,
        hasSeenOnboarding: false,
        isAuthenticated: false,
        currentLocation: '/',
        onboardingLocation: onboardingLocation,
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });

    test('redirects to /onboarding when onboarding not yet seen', () {
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: false,
          isAuthenticated: false,
          currentLocation: '/',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/onboarding'),
      );
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: false,
          isAuthenticated: false,
          currentLocation: '/login',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/onboarding'),
      );
    });

    test('returns null when onboarding not seen and already on /onboarding',
        () {
      final result = resolveAppRedirect(
        isLoading: false,
        hasSeenOnboarding: false,
        isAuthenticated: false,
        currentLocation: '/onboarding',
        onboardingLocation: onboardingLocation,
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });

    test('redirects from /onboarding or / to /login when onboarding seen and unauthenticated',
        () {
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: false,
          currentLocation: '/onboarding',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/login'),
      );
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: false,
          currentLocation: '/',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/login'),
      );
    });

    test('redirects from /onboarding or /login to / when authenticated', () {
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: true,
          currentLocation: '/onboarding',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/'),
      );
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: true,
          currentLocation: '/login',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        equals('/'),
      );
    });

    test('returns null for authenticated app routes after onboarding', () {
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: true,
          currentLocation: '/jurnal',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        isNull,
      );
      expect(
        resolveAppRedirect(
          isLoading: false,
          hasSeenOnboarding: true,
          isAuthenticated: true,
          currentLocation: '/profile',
          onboardingLocation: onboardingLocation,
          loginLocation: loginLocation,
          homeLocation: homeLocation,
        ),
        isNull,
      );
    });
  });

  group('resolveAuthRedirect', () {
    const loginLocation = '/login';
    const homeLocation = '/';

    test('returns null while auth state is loading', () {
      final result = resolveAuthRedirect(
        isLoading: true,
        isAuthenticated: false,
        currentLocation: '/',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });

    test('redirects unauthenticated user from home to /login', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: false,
        currentLocation: '/',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, equals('/login'));
    });

    test('redirects unauthenticated user from nested route to /login', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: false,
        currentLocation: '/jurnal',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, equals('/login'));
    });

    test('returns null when unauthenticated user is already on /login', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: false,
        currentLocation: '/login',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });

    test('redirects authenticated user away from /login to /', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: true,
        currentLocation: '/login',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, equals('/'));
    });

    test('returns null when authenticated user accesses /jurnal', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: true,
        currentLocation: '/jurnal',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });

    test('returns null when authenticated user accesses /', () {
      final result = resolveAuthRedirect(
        isLoading: false,
        isAuthenticated: true,
        currentLocation: '/',
        loginLocation: loginLocation,
        homeLocation: homeLocation,
      );

      expect(result, isNull);
    });
  });
}
