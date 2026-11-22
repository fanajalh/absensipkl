import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_ext.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../settings/presentation/widgets/ios_inset_grouped_list.dart';
import '../../domain/entities/history_filter.dart';
import '../notifiers/history_notifier.dart';
import '../widgets/attendance_detail_sheet.dart';
import '../widgets/attendance_history_tile.dart';
import '../widgets/recap_summary_strip.dart';

/// Orisale v4 Riwayat screen with 2 KPI tiles, Cupertino segment & grouped list.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: historyAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (error, _) => AppErrorView(
            error: error,
            onRetry: () => ref.invalidate(historyProvider),
            onReLogin: () => ref.read(authProvider.notifier).logout(),
          ),
          data: (viewState) {
            final monthDate = DateTime(viewState.year, viewState.month);
            final records = viewState.recap.records;
            final segmentValue = viewState.filter == HistoryFilter.absent
                ? HistoryFilter.all
                : viewState.filter;

            return RefreshIndicator.adaptive(
              onRefresh: () => ref.read(historyProvider.notifier).refresh(),
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
                      AppSpacing.xl + bottomInset,
                    ),
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Riwayat',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          Text(
                            monthDate.toIndonesianMonthYear(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontFeatures: const <FontFeature>[
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FadeSlideIn(
                        delayMs: 30,
                        child: RecapSummaryStrip(recap: viewState.recap),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CupertinoSlidingSegmentedControl<HistoryFilter>(
                        key: AppWidgetKeys.historyFilterSegment,
                        groupValue: segmentValue,
                        backgroundColor: colorScheme.secondaryContainer,
                        thumbColor: colorScheme.surface,
                        children: <HistoryFilter, Widget>{
                          HistoryFilter.all: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Semua',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          HistoryFilter.present: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Hadir',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          HistoryFilter.late: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Telat',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          HistoryFilter.leave: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Izin',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (filter) {
                          if (filter == null) return;
                          unawaited(HapticFeedback.selectionClick());
                          ref.read(historyProvider.notifier).setFilter(filter);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutExpo,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final slide = Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(animation);
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slide,
                              child: child,
                            ),
                          );
                        },
                        child: records.isEmpty
                            ? Container(
                                key: ValueKey<String>(
                                  'empty-${viewState.filter.name}',
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusLg,
                                  ),
                                  border: Border.all(
                                    color: colorScheme.outline,
                                    width: AppSpacing.hairlineBorder,
                                  ),
                                ),
                                child: const Text(
                                  'Belum ada catatan presensi untuk filter ini.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : KeyedSubtree(
                                key: ValueKey<String>(
                                  'list-${viewState.filter.name}-${records.length}',
                                ),
                                child: IosInsetGroupedList(
                                  children: <Widget>[
                                    for (var i = 0; i < records.length; i++)
                                      FadeSlideIn(
                                        delayMs: (i * 35).clamp(0, 220),
                                        durationMs: 360,
                                        offsetY: 14,
                                        child: AttendanceHistoryTile(
                                          record: records[i],
                                          onTap: () => _openDetailSheet(
                                            context,
                                            records[i],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
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

  void _openDetailSheet(BuildContext context, AttendanceRecord record) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => AttendanceDetailSheet(record: record),
    );
  }
}
