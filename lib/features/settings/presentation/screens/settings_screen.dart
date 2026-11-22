import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/location_datasource.dart';
import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_header_buttons.dart';
import '../../../attendance/presentation/notifiers/attendance_notifier.dart';
import '../../../attendance/presentation/widgets/geofence_demo_sheet.dart';
import '../../../update/presentation/notifiers/app_update_notifier.dart';
import '../../../update/presentation/widgets/app_update_sheet.dart';
import '../../domain/entities/app_settings.dart';
import '../notifiers/settings_notifier.dart';
import '../widgets/ios_inset_grouped_list.dart';

/// Concise Orisale v4 settings screen with debug-only QA GPS trigger.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsProvider).asData?.value ?? const AppSettings();
    final updateState = ref.watch(appUpdateProvider);
    final locationDs = ref.watch(locationDatasourceProvider);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 104,
        leading: AppHeaderBackButton(
          label: 'Profil',
          onPressed: () => context.pop(),
        ),
        title: const Text('Pengaturan'),
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
                IosInsetGroupedList(
                  children: <Widget>[
                    IosGroupedActionRow(
                      title: 'Pengingat Masuk',
                      subtitle: '07:45 WIB',
                      trailing: Switch.adaptive(
                        key: AppWidgetKeys.settingsCheckInReminderSwitch,
                        value: settings.checkInReminder,
                        onChanged: (value) => ref
                            .read(settingsProvider.notifier)
                            .setCheckInReminder(value),
                      ),
                    ),
                    IosGroupedActionRow(
                      title: 'Pengingat Jurnal',
                      subtitle: '16:30 WIB',
                      trailing: Switch.adaptive(
                        key: AppWidgetKeys.settingsJournalReminderSwitch,
                        value: settings.journalReminder,
                        onChanged: (value) => ref
                            .read(settingsProvider.notifier)
                            .setJournalReminder(value),
                      ),
                    ),
                    IosGroupedActionRow(
                      title: 'Mode Gelap',
                      trailing: Switch.adaptive(
                        key: AppWidgetKeys.settingsDarkModeSwitch,
                        value: settings.isDarkMode,
                        onChanged: (value) => ref
                            .read(settingsProvider.notifier)
                            .setDarkMode(value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                IosInsetGroupedList(
                  children: <Widget>[
                    const IosGroupedActionRow(
                      title: 'Lokasi GPS',
                      trailingText: 'Saat Digunakan',
                      trailingColor: AppColors.emerald,
                    ),
                    const IosGroupedActionRow(
                      title: 'Kamera Depan',
                      trailingText: 'Diizinkan',
                      trailingColor: AppColors.emerald,
                    ),
                    IosGroupedActionRow(
                      title: 'Anti Fake GPS',
                      trailingText: 'Aktif',
                      trailingColor: theme.colorScheme.primary,
                    ),
                    IosGroupedActionRow(
                      title: 'Pembaruan Aplikasi',
                      trailingText: updateState.status == AppUpdateStatus.checking
                          ? 'Memeriksa...'
                          : updateState.hasUpdate
                              ? 'v${updateState.release!.version}'
                              : 'v${updateState.currentVersion}',
                      trailingColor: updateState.hasUpdate
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      showChevron: true,
                      onTap: () async {
                        await ref
                            .read(appUpdateProvider.notifier)
                            .checkForUpdate();
                        if (!context.mounted) return;
                        final release = ref.read(appUpdateProvider).release;
                        await AppUpdateSheet.show(
                          context,
                          isMandatory: release?.isMandatory ?? false,
                        );
                      },
                    ),
                  ],
                ),
                if (kDebugMode && locationDs.isSimulationSupported) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  IosInsetGroupedList(
                    children: <Widget>[
                      IosGroupedActionRow(
                        key: AppWidgetKeys.settingsQaSimulationRow,
                        title: 'Simulasi QA',
                        trailingText: locationDs.currentPreset.label,
                        showChevron: true,
                        onTap: () => _openQaSimulationSheet(
                          context,
                          ref,
                          locationDs.currentPreset,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    'v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Future<void> _openQaSimulationSheet(
    BuildContext context,
    WidgetRef ref,
    DemoLocationPreset currentPreset,
  ) async {
    final selected = await showModalBottomSheet<DemoLocationPreset>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => GeofenceDemoSheet(
        options: <GeofenceDemoOption>[
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetInside,
            title: DemoLocationPreset.insideRadius.label,
            subtitle: DemoLocationPreset.insideRadius.description,
            isSelected: currentPreset == DemoLocationPreset.insideRadius,
            onTap: () => Navigator.of(sheetContext)
                .pop(DemoLocationPreset.insideRadius),
          ),
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetOutside,
            title: DemoLocationPreset.outsideRadius.label,
            subtitle: DemoLocationPreset.outsideRadius.description,
            isSelected: currentPreset == DemoLocationPreset.outsideRadius,
            onTap: () => Navigator.of(sheetContext)
                .pop(DemoLocationPreset.outsideRadius),
          ),
          GeofenceDemoOption(
            key: AppWidgetKeys.geofencePresetMock,
            title: DemoLocationPreset.mockGps.label,
            subtitle: DemoLocationPreset.mockGps.description,
            isSelected: currentPreset == DemoLocationPreset.mockGps,
            onTap: () =>
                Navigator.of(sheetContext).pop(DemoLocationPreset.mockGps),
          ),
        ],
      ),
    );
    if (!context.mounted || selected == null) return;
    await ref.read(attendanceProvider.notifier).setDemoPreset(selected);
  }
}
