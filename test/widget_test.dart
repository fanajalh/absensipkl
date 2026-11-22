import 'dart:convert';

import 'package:absensi_pkl/app.dart';
import 'package:absensi_pkl/core/constants/storage_keys.dart';
import 'package:absensi_pkl/core/services/secure_storage_datasource.dart';
import 'package:absensi_pkl/core/testing/app_widget_keys.dart';
import 'package:absensi_pkl/features/settings/data/models/app_settings_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'AbsensiPklApp renders OnboardingScreen on fresh launch when onboardingSeen is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(
            InMemorySecureStorageDatasource(),
          ),
        ],
        child: const AbsensiPklApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Absensi DUDI Akurat'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
  });

  testWidgets(
      'AbsensiPklApp renders LoginScreen when onboardingSeen is true and unauthenticated',
      (WidgetTester tester) async {
    final storage = InMemorySecureStorageDatasource();
    await storage.write(
      StorageKeys.appSettings,
      jsonEncode(const AppSettingsDto(onboardingSeen: true).toJson()),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secureStorageDatasourceProvider.overrideWithValue(storage),
        ],
        child: const AbsensiPklApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsWidgets);
    expect(find.byKey(AppWidgetKeys.loginSubmitButton), findsOneWidget);
  });
}
