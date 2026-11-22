import '../models/journal_entry_dto.dart';

/// Contract for PKL daily journal persistence.
abstract interface class JournalDatasource {
  Future<List<JournalEntryDto>> getEntries();

  Future<JournalEntryDto> saveEntry(JournalEntryDto entry);
}
