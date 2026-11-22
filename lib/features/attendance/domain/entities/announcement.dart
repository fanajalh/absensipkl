import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';

/// Pure domain entity representing a school/DUDI announcement for students.
@freezed
abstract class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String content,
    required String targetRole,
    required DateTime createdAt,
  }) = _Announcement;
}
