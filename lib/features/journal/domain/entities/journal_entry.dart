import 'package:freezed_annotation/freezed_annotation.dart';

import 'journal_validation_status.dart';

part 'journal_entry.freezed.dart';

/// Pure domain entity representing a student's daily PKL activity logbook entry.
@freezed
abstract class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required DateTime date,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required JournalValidationStatus status,
    String? photoUrl,
    String? mentorNote,
  }) = _JournalEntry;
}
