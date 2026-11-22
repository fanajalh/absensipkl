import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_character.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/character_refresh_indicator.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../domain/entities/journal_validation_status.dart';
import '../notifiers/journal_notifier.dart';
import '../widgets/journal_entry_card.dart';

/// Concise Orisale v4 PKL logbook list screen.
class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bannerBg =
        isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;

    return Scaffold(
      floatingActionButton: BouncyTap(
        key: AppWidgetKeys.addJournalButton,
        scaleDown: 0.9,
        onTap: () => const JournalFormRoute().go(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF29AAFF), Color(0xFF1594F5)],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x2E1FA2FF),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Text(
                    'Jurnal PKL',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: entriesAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (error, _) => AppErrorView(
                      error: error,
                      onRetry: () => ref.invalidate(journalProvider),
                      onReLogin: () => ref.read(authProvider.notifier).logout(),
                    ),
                    data: (entries) {
                      final approvedCount = entries
                          .where(
                            (e) => e.status == JournalValidationStatus.approved,
                          )
                          .length;
                      final pendingCount = entries
                          .where(
                            (e) => e.status == JournalValidationStatus.pending,
                          )
                          .length;

                      return CharacterRefreshIndicator(
                        onRefresh: () =>
                            ref.read(journalProvider.notifier).refresh(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            92 + MediaQuery.paddingOf(context).bottom,
                          ),
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: bannerBg,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusLg),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '$approvedCount Disetujui',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontFeatures: const <FontFeature>[
                                              FontFeature.tabularFigures(),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$pendingCount Menunggu',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontFeatures: const <FontFeature>[
                                              FontFeature.tabularFigures(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  SizedBox(
                                    width: 72,
                                    height: 54,
                                    child: GentleFloat(
                                      amplitude: 3.5,
                                      child: SvgPicture.asset(
                                        'assets/illustrations/undraw_checkin.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (entries.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.lg),
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
                                child: const AppEmptyCharacter(
                                  message: 'Belum ada jurnal.',
                                  assetPath:
                                      'assets/illustrations/undraw_jurnal.svg',
                                  imageHeight: 96,
                                ),
                              )
                            else
                              for (var i = 0; i < entries.length; i++) ...<Widget>[
                                FadeSlideIn(
                                  delayMs: (i * 55).clamp(0, 220),
                                  child: BouncyTap(
                                    scaleDown: 0.98,
                                    onTap: () => JournalFormRoute(
                                      entryId: entries[i].id,
                                    ).go(context),
                                    child: JournalEntryCard(
                                      entry: entries[i],
                                      onTap: () => JournalFormRoute(
                                        entryId: entries[i].id,
                                      ).go(context),
                                    ),
                                  ),
                                ),
                                if (i < entries.length - 1)
                                  const SizedBox(height: AppSpacing.md),
                              ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
