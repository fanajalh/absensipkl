import 'package:freezed_annotation/freezed_annotation.dart';

import 'dudi_placement.dart';

part 'student_profile.freezed.dart';

/// Pure domain entity representing an authenticated PKL student.
@freezed
abstract class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String id,
    required String nisn,
    required String fullName,
    required String className,
    required String major,
    required String email,
    required DudiPlacement placement,
  }) = _StudentProfile;
}
