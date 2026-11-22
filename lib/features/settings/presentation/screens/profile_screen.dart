import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_header_buttons.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../widgets/ios_inset_grouped_list.dart';
import '../widgets/profile_cards.dart';

/// Concise Orisale v4 student profile & DUDI placement screen.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final logoutBg = isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 118,
        leading: AppHeaderBackButton(
          label: 'Beranda',
          onPressed: () => context.pop(),
        ),
        title: const Text('Profil Siswa'),
        actions: <Widget>[
          AppHeaderActionButton(
            key: AppWidgetKeys.settingsButton,
            label: 'Atur',
            icon: Icons.tune_rounded,
            onPressed: () => const SettingsRoute().push<void>(context),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl + bottomInset,
              ),
              children: <Widget>[
                ProfileStudentCard(student: student),
                const SizedBox(height: AppSpacing.md),
                ProfileDudiCard(student: student),
                const SizedBox(height: AppSpacing.lg),
                IosInsetGroupedList(
                  children: <Widget>[
                    const IosGroupedActionRow(
                      title: 'Device ID',
                      trailingText: 'Aktif',
                      trailingColor: AppColors.emerald,
                    ),
                    IosGroupedActionRow(
                      title: 'Pengaturan',
                      showChevron: true,
                      onTap: () => const SettingsRoute().push<void>(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: logoutBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: InkWell(
                    key: AppWidgetKeys.logoutButton,
                    onTap: () => _confirmLogout(context, ref),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: AppSpacing.ctaHeight,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Keluar Akun',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.rose,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: const Text('Keluar Akun?'),
        content: const Text('Sesi akun akan diakhiri.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    await ref.read(authProvider.notifier).logout();
  }
}
