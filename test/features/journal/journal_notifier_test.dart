import 'package:absensi_pkl/core/errors/app_error.dart';
import 'package:absensi_pkl/features/journal/data/datasources/demo_journal_datasource.dart';
import 'package:absensi_pkl/features/journal/data/datasources/journal_datasource.dart';
import 'package:absensi_pkl/features/journal/data/models/journal_entry_dto.dart';
import 'package:absensi_pkl/features/journal/domain/entities/journal_entry.dart';
import 'package:absensi_pkl/features/journal/domain/entities/journal_validation_status.dart';
import 'package:absensi_pkl/features/journal/presentation/notifiers/journal_notifier.dart';
import 'package:absensi_pkl/features/journal/repositories/journal_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingRefreshJournalDatasource implements JournalDatasource {
  bool shouldFail = false;

  @override
  Future<List<JournalEntryDto>> getEntries() async {
    if (shouldFail) {
      throw const AppError.network(message: 'Koneksi ke server jurnal terputus.');
    }
    return <JournalEntryDto>[];
  }

  @override
  Future<JournalEntryDto> saveEntry(JournalEntryDto entry) async => entry;
}

JournalEntry _buildEntry({
  String title = 'Implementasi Modul Presensi',
  String description =
      'Membuat test unit untuk validasi jurnal harian siswa PKL.',
  String startTime = '08:00',
  String endTime = '17:00',
}) {
  return JournalEntry(
    id: '',
    date: DateTime(2026, 4, 15),
    title: title,
    description: description,
    startTime: startTime,
    endTime: endTime,
    status: JournalValidationStatus.pending,
  );
}

void main() {
  group('JournalNotifier', () {
    test('rejects empty title', () async {
      final container = ProviderContainer.test(
        overrides: [
          journalDatasourceProvider.overrideWithValue(
            DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 10)),
          ),
        ],
      );

      await container.read(journalProvider.future);

      await expectLater(
        () => container
            .read(journalProvider.notifier)
            .saveEntry(_buildEntry(title: '   ')),
        throwsA(isA<ValidationError>()),
      );
    });

    test('rejects description shorter than 15 characters', () async {
      final container = ProviderContainer.test(
        overrides: [
          journalDatasourceProvider.overrideWithValue(
            DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 10)),
          ),
        ],
      );

      await container.read(journalProvider.future);

      await expectLater(
        () => container
            .read(journalProvider.notifier)
            .saveEntry(_buildEntry(description: 'Terlalu pendek')),
        throwsA(
          isA<ValidationError>().having(
            (e) => e.message,
            'message',
            contains('minimal 15 karakter'),
          ),
        ),
      );
    });

    test('rejects endTime equal to or earlier than startTime', () async {
      final container = ProviderContainer.test(
        overrides: [
          journalDatasourceProvider.overrideWithValue(
            DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 10)),
          ),
        ],
      );

      await container.read(journalProvider.future);

      await expectLater(
        () => container.read(journalProvider.notifier).saveEntry(
              _buildEntry(startTime: '09:00', endTime: '09:00'),
            ),
        throwsA(isA<ValidationError>()),
      );

      await expectLater(
        () => container.read(journalProvider.notifier).saveEntry(
              _buildEntry(startTime: '14:00', endTime: '13:30'),
            ),
        throwsA(isA<ValidationError>()),
      );
    });

    test('creates valid journal entry and updates notifier list', () async {
      final container = ProviderContainer.test(
        overrides: [
          journalDatasourceProvider.overrideWithValue(
            DemoJournalDatasource(clock: () => DateTime(2026, 4, 15, 10)),
          ),
        ],
      );

      final initial = await container.read(journalProvider.future);
      expect(initial.length, equals(3));

      await container.read(journalProvider.notifier).saveEntry(_buildEntry());

      final updated = container.read(journalProvider).requireValue;
      expect(updated.length, equals(4));
      expect(updated.first.title, equals('Implementasi Modul Presensi'));
      expect(updated.first.status, equals(JournalValidationStatus.pending));
    });

    test('surfaces AsyncError on refresh failure rather than hanging in loading',
        () async {
      final datasource = _FailingRefreshJournalDatasource();
      final container = ProviderContainer.test(
        overrides: [
          journalDatasourceProvider.overrideWithValue(datasource),
        ],
      );

      await container.read(journalProvider.future);

      datasource.shouldFail = true;
      await container.read(journalProvider.notifier).refresh();

      final state = container.read(journalProvider);
      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.error, isA<NetworkError>());
    });
  });
}
