import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/dudi_placement.dart';
import 'announcement.dart';
import 'attendance_record.dart';

part 'siswa_home_snapshot.freezed.dart';

/// Pure domain snapshot returned by `/siswa/home`.
@freezed
abstract class SiswaHomeSnapshot with _$SiswaHomeSnapshot {
  const factory SiswaHomeSnapshot({
    DudiPlacement? placement,
    AttendanceRecord? todayRecord,
    @Default(0) int approvedJournalsCount,
    @Default(120) int targetDays,
    @Default(<Announcement>[]) List<Announcement> announcements,
  }) = _SiswaHomeSnapshot;
}
