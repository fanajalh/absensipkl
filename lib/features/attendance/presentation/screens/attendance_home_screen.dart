import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/character_refresh_indicator.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../history/presentation/notifiers/history_notifier.dart';
import '../../../journal/domain/entities/journal_entry.dart';
import '../../../journal/domain/entities/journal_validation_status.dart';
import '../../../journal/presentation/notifiers/journal_notifier.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/geofence_evaluation.dart';
import '../notifiers/attendance_notifier.dart';
import '../notifiers/live_clock_notifier.dart';
import '../widgets/announcements_sheet.dart';
import '../widgets/attendance_feedback_banner.dart';
import '../widgets/beranda_kpi_row.dart';
import '../widgets/beranda_shortcut_grid.dart';
import '../widgets/beranda_top_bar.dart';
import '../widgets/orisale_latest_activity_card.dart';
import '../widgets/orisale_weekly_recap_card.dart';

/// Concise Orisale v4 Beranda dashboard synced with `/siswa/home`.
class AttendanceHomeScreen extends ConsumerWidget {
  const AttendanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final student = switch (authState) {
      AuthAuthenticated(:final session) => session.student,
      _ => null,
    };

    if (student == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final attendanceAsync = ref.watch(attendanceProvider);
    final journals =
        ref.watch(journalProvider).asData?.value ?? const <JournalEntry>[];
    final localApproved = journals
        .where((entry) => entry.status == JournalValidationStatus.approved)
        .length;
    final historyRecap = ref.watch(historyProvider).asData?.value.recap;
    final attendedDays = historyRecap == null
        ? 0
        : historyRecap.presentCount + historyRecap.lateCount;

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: attendanceAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, _) => AppErrorView(
            error: error,
            onRetry: () => ref.invalidate(attendanceProvider),
            onReLogin: () => ref.read(authProvider.notifier).logout(),
          ),
          data: (dashboard) {
            final placement = dashboard.placement ?? student.placement;
            final approvedJournals = dashboard.approvedJournalsCount > 0
                ? dashboard.approvedJournalsCount
                : localApproved;

            return CharacterRefreshIndicator(
              onRefresh: () =>
                  ref.read(attendanceProvider.notifier).refreshLocation(),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
                    ),
                    children: <Widget>[
                      BerandaTopBar(
                        isRefreshing: dashboard.isRefreshingLocation,
                        hasAnnouncements: dashboard.announcements.isNotEmpty,
                        onAvatarTap: () =>
                            const ProfileRoute().push<void>(context),
                        onAnnouncementsTap: () => _openAnnouncements(
                          context,
                          dashboard.announcements,
                        ),
                        onRefreshTap: () => ref
                            .read(attendanceProvider.notifier)
                            .refreshLocation(),
                        onMapTap: () =>
                            const AttendanceMapRoute().push<void>(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FadeSlideIn(
                        delayMs: 30,
                        child: _BerandaKpiClockSection(
                          todayRecord: dashboard.todayRecord,
                          geofence: dashboard.geofence,
                          isBusy: dashboard.isSubmitting ||
                              dashboard.isRefreshingLocation,
                          onCheckActionTap: () =>
                              _handleSelfieAction(context, ref),
                          onMapTap: () =>
                              const AttendanceMapRoute().push<void>(context),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FadeSlideIn(
                        delayMs: 80,
                        child: BerandaShortcutGrid(
                          onSelfieTap: () => _handleSelfieAction(context, ref),
                          onMapTap: () =>
                              const AttendanceMapRoute().push<void>(context),
                          onJournalTap: () =>
                              const JournalFormRoute().push<void>(context),
                          onLeaveTap: () => const IzinRoute().go(context),
                        ),
                      ),
                      if (dashboard.actionError != null) ...<Widget>[
                        const SizedBox(height: AppSpacing.md),
                        AttendanceFeedbackBanner(
                          message: dashboard.actionError!.userMessage,
                          isError: true,
                          onDismiss: () => ref
                              .read(attendanceProvider.notifier)
                              .clearBanner(),
                        ),
                      ] else if (dashboard.actionSuccessMessage != null) ...<Widget>[
                        const SizedBox(height: AppSpacing.md),
                        AttendanceFeedbackBanner(
                          message: dashboard.actionSuccessMessage!,
                          isError: false,
                          onDismiss: () => ref
                              .read(attendanceProvider.notifier)
                              .clearBanner(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      FadeSlideIn(
                        delayMs: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Rekap Mingguan',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            OrisaleWeeklyRecapCard(
                              attendedDays: attendedDays,
                              targetDays: dashboard.targetDays,
                              approvedJournals: approvedJournals,
                              onTap: () => const RiwayatRoute().go(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FadeSlideIn(
                        delayMs: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Aktivitas',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            OrisaleLatestActivityCard(
                              companyName: placement.companyName,
                              onTap: () => const JurnalRoute().go(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openAnnouncements(
    BuildContext context,
    List<Announcement> announcements,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => AnnouncementsSheet(announcements: announcements),
    );
  }

  Future<void> _handleSelfieAction(
    BuildContext context,
    WidgetRef ref,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final evaluation = await ref
        .read(attendanceProvider.notifier)
        .validateGeofenceForSelfie();
    if (!context.mounted || evaluation == null) return;
    await const AttendanceSelfieRoute().push<void>(context);
  }
}

/// Isolates the 1-second [liveClockProvider] subscription to the KPI row.
class _BerandaKpiClockSection extends ConsumerWidget {
  const _BerandaKpiClockSection({
    required this.todayRecord,
    required this.geofence,
    required this.isBusy,
    required this.onCheckActionTap,
    required this.onMapTap,
  });

  final AttendanceRecord? todayRecord;
  final GeofenceEvaluation? geofence;
  final bool isBusy;
  final VoidCallback onCheckActionTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(liveClockProvider);
    return BerandaKpiRow(
      currentTime: currentTime,
      todayRecord: todayRecord,
      geofence: geofence,
      isBusy: isBusy,
      onCheckActionTap: onCheckActionTap,
      onMapTap: onMapTap,
    );
  }
}
