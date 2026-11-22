import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/core/services/camera_datasource.dart';
import 'package:absensi_pkl/core/testing/app_widget_keys.dart';
import 'package:absensi_pkl/core/theme/app_theme.dart';
import 'package:absensi_pkl/features/journal/data/datasources/demo_journal_datasource.dart';
import 'package:absensi_pkl/features/journal/domain/entities/journal_entry.dart';
import 'package:absensi_pkl/features/journal/domain/repositories/journal_repository.dart';
import 'package:absensi_pkl/features/journal/presentation/notifiers/journal_notifier.dart';
import 'package:absensi_pkl/features/journal/presentation/screens/journal_form_screen.dart';
import 'package:absensi_pkl/features/journal/repositories/journal_repository_impl.dart';
import 'package:absensi_pkl/features/leave/data/datasources/demo_leave_datasource.dart';
import 'package:absensi_pkl/features/leave/domain/entities/leave_request.dart';
import 'package:absensi_pkl/features/leave/domain/repositories/leave_repository.dart';
import 'package:absensi_pkl/features/leave/presentation/screens/leave_form_screen.dart';
import 'package:absensi_pkl/features/leave/repositories/leave_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _TestCameraDatasource implements CameraDatasource {
  @override
  Future<CapturedSelfie?> captureSelfie() async => CapturedSelfie(
        fileName: 'surat_sakit.jpg',
        mimeType: 'image/jpeg',
        capturedAt: DateTime(2026, 4, 15, 9),
      );

  @override
  Future<CapturedSelfie?> captureJournalPhoto({bool fromGallery = false}) async =>
      CapturedSelfie(
        fileName: fromGallery ? 'galeri_jurnal.jpg' : 'kamera_jurnal.jpg',
        mimeType: 'image/jpeg',
        capturedAt: DateTime(2026, 4, 15, 9),
      );
}

class _RejectingTimeJournalRepository implements JournalRepository {
  @override
  Future<List<JournalEntry>> getEntries() async => <JournalEntry>[];

  @override
  Future<JournalEntry> saveEntry(JournalEntry entry) async {
    throw const AppError.validation(
      message: 'Jam selesai harus lebih akhir daripada jam mulai.',
    );
  }
}

class _RejectingDateLeaveRepository implements LeaveRepository {
  @override
  Future<List<LeaveRequest>> getRequests() async => <LeaveRequest>[];

  @override
  Future<LeaveRequest> submitRequest(LeaveRequest request) async {
    throw const AppError.validation(
      message: 'Tanggal selesai tidak boleh lebih awal dari tanggal mulai.',
    );
  }
}

Widget _buildRoutedHost({
  required ProviderContainer container,
  required Widget formScreen,
}) {
  final router = GoRouter(
    initialLocation: '/form',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('LIST_HOME')),
        routes: [
          GoRoute(
            path: 'form',
            builder: (_, _) => formScreen,
          ),
        ],
      ),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  testWidgets(
      'JournalFormScreen displays validation feedback on empty/short inputs and repository errors, and saves valid entry at 375pt width',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        journalDatasourceProvider.overrideWithValue(
          DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 10)),
        ),
      ],
    );

    await tester.pumpWidget(
      _buildRoutedHost(
        container: container,
        formScreen: const JournalFormScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Empty submit shows inline validation messages
    await tester.ensureVisible(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.tap(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.pumpAndSettle();

    expect(find.text('Judul kegiatan wajib diisi.'), findsOneWidget);
    expect(find.text('Deskripsi minimal 15 karakter.'), findsOneWidget);

    // Short description (< 15 chars) still blocked
    await tester.enterText(
      find.byKey(AppWidgetKeys.journalTitleField),
      'Testing Integrasi API',
    );
    await tester.enterText(
      find.byKey(AppWidgetKeys.journalDescriptionField),
      'Singkat saja',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.tap(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.pumpAndSettle();

    expect(find.text('Judul kegiatan wajib diisi.'), findsNothing);
    expect(find.text('Deskripsi minimal 15 karakter.'), findsOneWidget);

    // Valid description succeeds and pops back to list
    await tester.enterText(
      find.byKey(AppWidgetKeys.journalDescriptionField),
      'Menulis automated widget test untuk halaman form jurnal PKL.',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.tap(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.pumpAndSettle();

    expect(find.text('LIST_HOME'), findsOneWidget);
    final savedEntries = await container.read(journalProvider.future);
    expect(savedEntries.length, equals(4));

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets(
      'JournalFormScreen surfaces repository validation error banner on invalid time range',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        journalRepositoryProvider.overrideWithValue(
          _RejectingTimeJournalRepository(),
        ),
      ],
    );

    await tester.pumpWidget(
      _buildRoutedHost(
        container: container,
        formScreen: const JournalFormScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(AppWidgetKeys.journalTitleField),
      'Validasi Rentang Jam',
    );
    await tester.enterText(
      find.byKey(AppWidgetKeys.journalDescriptionField),
      'Menguji tampilan pesan error ketika jam selesai tidak valid.',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.tap(find.byKey(AppWidgetKeys.journalSaveButton));
    await tester.pumpAndSettle();

    expect(
      find.text('Jam selesai harus lebih akhir daripada jam mulai.'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets(
      'LeaveFormScreen displays validation feedback on short reason, surfaces date-range error banner, and submits valid request at 375pt width',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final errorContainer = ProviderContainer(
      overrides: [
        cameraDatasourceProvider.overrideWithValue(_TestCameraDatasource()),
        leaveRepositoryProvider.overrideWithValue(
          _RejectingDateLeaveRepository(),
        ),
      ],
    );

    await tester.pumpWidget(
      _buildRoutedHost(
        container: errorContainer,
        formScreen: const LeaveFormScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Short reason (< 10 chars) shows inline form validation
    await tester.enterText(
      find.byKey(AppWidgetKeys.leaveReasonField),
      'Sakit',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.pumpAndSettle();

    expect(find.text('Keterangan minimal 10 karakter.'), findsOneWidget);

    // Valid reason with invalid date range surfaced from repository shows banner
    await tester.enterText(
      find.byKey(AppWidgetKeys.leaveReasonField),
      'Sakit demam dan perlu istirahat di rumah.',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.pumpAndSettle();

    expect(
      find.text('Tanggal selesai tidak boleh lebih awal dari tanggal mulai.'),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    errorContainer.dispose();

    // Valid submission succeeds and pops back to list
    final validContainer = ProviderContainer(
      overrides: [
        cameraDatasourceProvider.overrideWithValue(_TestCameraDatasource()),
        leaveDatasourceProvider.overrideWithValue(
          DemoLeaveDatasource(clock: () => DateTime(2026, 4, 15, 9)),
        ),
      ],
    );

    await tester.pumpWidget(
      _buildRoutedHost(
        container: validContainer,
        formScreen: const LeaveFormScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(AppWidgetKeys.leaveReasonField),
      'Mengikuti ujian kompetensi kejuruan di sekolah.',
    );
    await tester.ensureVisible(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.tap(find.byKey(AppWidgetKeys.leaveSubmitButton));
    await tester.pumpAndSettle();

    expect(find.text('LIST_HOME'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    validContainer.dispose();
  });
}
