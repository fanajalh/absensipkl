import 'dart:convert';

import 'package:absensi_pkl/core/constants/storage_keys.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/features/settings/domain/entities/app_settings.dart';
import 'package:absensi_pkl/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsNotifier', () {
    test('loads default AppSettings when secure storage is empty', () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
        ],
      );

      final loaded = await container.read(settingsProvider.future);

      expect(
        loaded,
        equals(
          const AppSettings(
            onboardingSeen: false,
            checkInReminder: true,
            journalReminder: true,
            isDarkMode: false,
          ),
        ),
      );
    });

    test(
        'toggles onboardingSeen, isDarkMode, checkInReminder, journalReminder and persists across containers',
        () async {
      final storage = InMemorySecureStorageDatasource();
      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
        ],
      );

      await container.read(settingsProvider.future);
      final notifier = container.read(settingsProvider.notifier);

      await notifier.completeOnboarding();
      await notifier.setDarkMode(true);
      await notifier.setCheckInReminder(false);
      await notifier.setJournalReminder(false);

      final updated = container.read(settingsProvider).requireValue;
      expect(updated.onboardingSeen, isTrue);
      expect(updated.isDarkMode, isTrue);
      expect(updated.checkInReminder, isFalse);
      expect(updated.journalReminder, isFalse);

      final raw = await storage.read(StorageKeys.appSettings);
      expect(raw, isNotNull);
      final decoded = jsonDecode(raw!) as Map<String, dynamic>;
      expect(decoded['onboardingSeen'], isTrue);
      expect(decoded['isDarkMode'], isTrue);
      expect(decoded['checkInReminder'], isFalse);
      expect(decoded['journalReminder'], isFalse);

      // Fresh container sharing the same storage restores persisted toggles
      final restoredContainer = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
        ],
      );
      final restored = await restoredContainer.read(settingsProvider.future);
      expect(restored, equals(updated));
    });

    test('falls back to default AppSettings when stored JSON is corrupted',
        () async {
      final storage = InMemorySecureStorageDatasource();
      await storage.write(StorageKeys.appSettings, '{corrupt_json');

      final container = ProviderContainer.test(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
        ],
      );

      final loaded = await container.read(settingsProvider.future);
      expect(loaded, equals(const AppSettings()));
    });
  });
}
