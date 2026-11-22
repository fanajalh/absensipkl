import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_settings.dart';
import '../../repositories/settings_repository_impl.dart';

part 'settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<AppSettings> build() =>
      ref.watch(settingsRepositoryProvider).loadSettings();

  Future<void> completeOnboarding() => _update(
        (current) => current.copyWith(onboardingSeen: true),
      );

  Future<void> setCheckInReminder(bool enabled) => _update(
        (current) => current.copyWith(checkInReminder: enabled),
      );

  Future<void> setJournalReminder(bool enabled) => _update(
        (current) => current.copyWith(journalReminder: enabled),
      );

  Future<void> setDarkMode(bool enabled) => _update(
        (current) => current.copyWith(isDarkMode: enabled),
      );

  Future<void> _update(AppSettings Function(AppSettings) transform) async {
    final current = state.asData?.value ?? const AppSettings();
    final updated = transform(current);
    state = AsyncData(updated);
    final saved =
        await ref.read(settingsRepositoryProvider).saveSettings(updated);
    if (!ref.mounted) return;
    state = AsyncData(saved);
  }
}
