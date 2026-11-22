// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryDto _$JournalEntryDtoFromJson(Map<String, dynamic> json) =>
    JournalEntryDto(
      id: json['id'] as String,
      dateIso: json['dateIso'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      statusName: json['statusName'] as String,
      photoUrl: json['photoUrl'] as String?,
      mentorNote: json['mentorNote'] as String?,
    );

Map<String, dynamic> _$JournalEntryDtoToJson(JournalEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateIso': instance.dateIso,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'statusName': instance.statusName,
      'photoUrl': instance.photoUrl,
      'mentorNote': instance.mentorNote,
    };
