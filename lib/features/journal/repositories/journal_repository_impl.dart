import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../data/datasources/demo_journal_datasource.dart';
import '../data/datasources/journal_datasource.dart';
import '../data/datasources/remote_journal_datasource.dart';
import '../data/models/journal_entry_dto.dart';
import '../domain/entities/journal_entry.dart';
import '../domain/repositories/journal_repository.dart';

part 'journal_repository_impl.g.dart';

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._datasource);

  final JournalDatasource _datasource;

  @override
  Future<List<JournalEntry>> getEntries() async {
    final dtos = await _datasource.getEntries();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<JournalEntry> saveEntry(JournalEntry entry) async {
    final title = entry.title.trim();
    final description = entry.description.trim();

    if (title.isEmpty) {
      throw const AppError.validation(
        message: 'Judul kegiatan wajib diisi.',
      );
    }
    if (description.length < 15) {
      throw const AppError.validation(
        message: 'Deskripsi minimal 15 karakter.',
      );
    }
    if (!_isValidTimeRange(entry.startTime, entry.endTime)) {
      throw const AppError.validation(
        message: 'Jam selesai harus lebih akhir.',
      );
    }

    final savedDto = await _datasource.saveEntry(
      JournalEntryDto.fromEntity(
        entry.copyWith(
          title: title,
          description: description,
        ),
      ),
    );
    return savedDto.toEntity();
  }

  bool _isValidTimeRange(String startTime, String endTime) {
    final startMinutes = _toMinutes(startTime);
    final endMinutes = _toMinutes(endTime);
    if (startMinutes == null || endMinutes == null) return false;
    return endMinutes > startMinutes;
  }

  int? _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    if (h < 0 || h > 23 || m < 0 || m > 59) return null;
    return (h * 60) + m;
  }
}

@Riverpod(keepAlive: true)
JournalDatasource journalDatasource(Ref ref) => AppConfig.useDemoMode
    ? DemoJournalDatasource()
    : RemoteJournalDatasource(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
JournalRepository journalRepository(Ref ref) =>
    JournalRepositoryImpl(ref.watch(journalDatasourceProvider));
