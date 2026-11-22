import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_validation_status.dart';

part 'journal_entry_dto.g.dart';

@JsonSerializable()
class JournalEntryDto {
  const JournalEntryDto({
    required this.id,
    required this.dateIso,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.statusName,
    this.photoUrl,
    this.mentorNote,
  });

  factory JournalEntryDto.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryDtoFromJson(json);

  factory JournalEntryDto.fromEntity(JournalEntry entity) => JournalEntryDto(
        id: entity.id,
        dateIso: entity.date.toIso8601String(),
        title: entity.title,
        description: entity.description,
        startTime: entity.startTime,
        endTime: entity.endTime,
        statusName: entity.status.name,
        photoUrl: entity.photoUrl,
        mentorNote: entity.mentorNote,
      );

  final String id;
  final String dateIso;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String statusName;
  final String? photoUrl;
  final String? mentorNote;

  Map<String, dynamic> toJson() => _$JournalEntryDtoToJson(this);

  JournalEntry toEntity() => JournalEntry(
        id: id,
        date: DateTime.parse(dateIso),
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        status: JournalValidationStatus.values.firstWhere(
          (value) => value.name == statusName,
          orElse: () => JournalValidationStatus.pending,
        ),
        photoUrl: photoUrl,
        mentorNote: mentorNote,
      );
}
