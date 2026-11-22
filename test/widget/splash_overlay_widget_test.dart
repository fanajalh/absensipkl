import 'package:absensi_pkl/core/theme/app_theme.dart';
import 'package:absensi_pkl/core/widgets/app_splash_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AppSplashOverlay renders brand identity and smoothly dismisses to child',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const AppSplashOverlay(
            forceShowInTests: true,
            holdDuration: Duration(milliseconds: 200),
            exitDuration: Duration(milliseconds: 120),
            child: Scaffold(body: Center(child: Text('Main App Ready'))),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text('Absensi PKL'), findsOneWidget);
      expect(find.text('PT fanajalh.id'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.text('Absensi PKL'), findsNothing);
      expect(find.text('Main App Ready'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
