import '../entities/journal_entry.dart';

/// Contract for creating, editing, and fetching daily PKL journal entries.
abstract interface class JournalRepository {
  Future<List<JournalEntry>> getEntries();

  Future<JournalEntry> saveEntry(JournalEntry entry);
}
