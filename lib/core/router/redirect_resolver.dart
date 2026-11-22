/// Pure, unit-testable redirect resolver for typed GoRouter onboarding & auth guards.
String? resolveAppRedirect({
  required bool isLoading,
  required bool hasSeenOnboarding,
  required bool isAuthenticated,
  required String currentLocation,
  required String onboardingLocation,
  required String loginLocation,
  required String homeLocation,
}) {
  if (isLoading) return null;

  if (!hasSeenOnboarding) {
    return currentLocation == onboardingLocation ? null : onboardingLocation;
  }

  final isOnLogin = currentLocation == loginLocation;
  final isOnOnboarding = currentLocation == onboardingLocation;

  if (!isAuthenticated) {
    return isOnLogin ? null : loginLocation;
  }

  if (isOnLogin || isOnOnboarding) {
    return homeLocation;
  }

  return null;
}

/// Legacy compatibility wrapper assuming onboarding has already been completed.
String? resolveAuthRedirect({
  required bool isLoading,
  required bool isAuthenticated,
  required String currentLocation,
  required String loginLocation,
  required String homeLocation,
}) =>
    resolveAppRedirect(
      isLoading: isLoading,
      hasSeenOnboarding: true,
      isAuthenticated: isAuthenticated,
      currentLocation: currentLocation,
      onboardingLocation: '/onboarding',
      loginLocation: loginLocation,
      homeLocation: homeLocation,
    );
