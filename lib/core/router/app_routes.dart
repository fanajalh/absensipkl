import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/attendance_home_screen.dart';
import '../../features/attendance/presentation/screens/attendance_map_screen.dart';
import '../../features/attendance/presentation/screens/attendance_selfie_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/journal/presentation/screens/journal_form_screen.dart';
import '../../features/journal/presentation/screens/journal_list_screen.dart';
import '../../features/leave/presentation/screens/leave_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'app_navigation_shell.dart';

part 'app_routes.g.dart';

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<AttendanceMapRoute>(path: '/attendance/map')
class AttendanceMapRoute extends GoRouteData with $AttendanceMapRoute {
  const AttendanceMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AttendanceMapScreen();
}

@TypedGoRoute<AttendanceSelfieRoute>(path: '/attendance/selfie')
class AttendanceSelfieRoute extends GoRouteData with $AttendanceSelfieRoute {
  const AttendanceSelfieRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AttendanceSelfieScreen();
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<PresensiBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<PresensiRoute>(path: '/'),
      ],
    ),
    TypedStatefulShellBranch<JurnalBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<JurnalRoute>(
          path: '/jurnal',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<JournalFormRoute>(path: 'form'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<IzinBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<IzinRoute>(path: '/izin'),
      ],
    ),
    TypedStatefulShellBranch<RiwayatBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<RiwayatRoute>(path: '/riwayat'),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      AppNavigationShell(navigationShell: navigationShell);
}

class PresensiBranchData extends StatefulShellBranchData {
  const PresensiBranchData();
}

class JurnalBranchData extends StatefulShellBranchData {
  const JurnalBranchData();
}

class IzinBranchData extends StatefulShellBranchData {
  const IzinBranchData();
}

class RiwayatBranchData extends StatefulShellBranchData {
  const RiwayatBranchData();
}

class PresensiRoute extends GoRouteData with $PresensiRoute {
  const PresensiRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AttendanceHomeScreen();
}

class JurnalRoute extends GoRouteData with $JurnalRoute {
  const JurnalRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const JournalListScreen();
}

class JournalFormRoute extends GoRouteData with $JournalFormRoute {
  const JournalFormRoute({this.entryId});

  final String? entryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      JournalFormScreen(entryId: entryId);
}

class IzinRoute extends GoRouteData with $IzinRoute {
  const IzinRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LeaveScreen();
}

class RiwayatRoute extends GoRouteData with $RiwayatRoute {
  const RiwayatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HistoryScreen();
}
