import '../../../../core/errors/app_error.dart';
import '../../../../core/extensions/date_time_ext.dart';
import '../../domain/entities/attendance_status.dart';
import '../models/announcement_dto.dart';
import '../models/attendance_record_dto.dart';
import '../models/check_in_payload_dto.dart';
import '../models/siswa_home_dto.dart';
import 'attendance_datasource.dart';

/// In-memory seeded attendance store for demo & offline testing.
class DemoAttendanceDatasource implements AttendanceDatasource {
  DemoAttendanceDatasource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now {
    _records.addAll(_seedCurrentMonthRecords(_clock()));
  }

  final DateTime Function() _clock;
  final List<AttendanceRecordDto> _records = <AttendanceRecordDto>[];

  @override
  Future<SiswaHomeDto?> getHomeSummary() async {
    final today = await getTodayRecord();
    final now = _clock();
    return SiswaHomeDto(
      todayRecord: today,
      approvedJournalsCount: 3,
      targetDays: 120,
      announcements: <AnnouncementDto>[
        AnnouncementDto(
          id: 'ann-1',
          title: 'Batas Jam Check-In',
          content: 'Check-in DUDI sebelum 08:00 WIB.',
          targetRole: 'SISWA',
          createdAtIso: now.toIso8601String(),
        ),
        AnnouncementDto(
          id: 'ann-2',
          title: 'Pengumpulan Logbook',
          content: 'Lengkapi jurnal harian setiap hari Jumat.',
          targetRole: 'SISWA',
          createdAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        ),
      ],
    );
  }

  @override
  Future<AttendanceRecordDto?> getTodayRecord() async {
    final today = _clock();
    for (final record in _records) {
      if (DateTime.parse(record.dateIso).isSameCalendarDay(today)) {
        return record;
      }
    }
    return null;
  }

  @override
  Future<List<AttendanceRecordDto>> getAllRecords() async {
    final sorted = List<AttendanceRecordDto>.of(_records)
      ..sort((a, b) => DateTime.parse(b.dateIso).compareTo(DateTime.parse(a.dateIso)));
    return List<AttendanceRecordDto>.unmodifiable(sorted);
  }

  @override
  Future<AttendanceRecordDto> submitCheckIn({
    required CheckInPayloadDto payload,
    required String workStartTime,
  }) async {
    final now = _clock();
    final existing = await getTodayRecord();
    if (existing != null && existing.checkInTimeIso != null) {
      throw const AppError.validation(
        message: 'Anda sudah melakukan check-in hari ini.',
      );
    }

    final isLate = _isCheckInLate(now: now, workStartTime: workStartTime);
    final status = isLate ? AttendanceStatus.late : AttendanceStatus.present;

    final created = AttendanceRecordDto(
      id: 'att-${now.year}-${now.month}-${now.day}',
      dateIso: DateTime(now.year, now.month, now.day).toIso8601String(),
      statusName: status.name,
      checkInTimeIso: now.toIso8601String(),
      checkInDistanceMeters: payload.distanceMeters,
      isMockLocationFlagged: payload.isMocked,
      selfieLabel: payload.selfieLabel,
      notes: isLate
          ? 'Check-in melewati jam masuk $workStartTime WIB'
          : 'Check-in tepat waktu di area DUDI',
    );

    _records.removeWhere(
      (r) => DateTime.parse(r.dateIso).isSameCalendarDay(now),
    );
    _records.add(created);
    return created;
  }

  @override
  Future<AttendanceRecordDto> submitCheckOut({
    required CheckInPayloadDto payload,
  }) async {
    final now = _clock();
    final index = _records.indexWhere(
      (r) => DateTime.parse(r.dateIso).isSameCalendarDay(now),
    );
    if (index == -1 || _records[index].checkInTimeIso == null) {
      throw const AppError.validation(
        message: 'Silakan lakukan check-in terlebih dahulu sebelum check-out.',
      );
    }
    final current = _records[index];
    if (current.checkOutTimeIso != null) {
      throw const AppError.validation(
        message: 'Anda sudah melakukan check-out hari ini.',
      );
    }

    final updated = AttendanceRecordDto(
      id: current.id,
      dateIso: current.dateIso,
      statusName: current.statusName,
      checkInTimeIso: current.checkInTimeIso,
      checkOutTimeIso: now.toIso8601String(),
      checkInDistanceMeters: current.checkInDistanceMeters,
      checkOutDistanceMeters: payload.distanceMeters,
      isMockLocationFlagged:
          current.isMockLocationFlagged || payload.isMocked,
      selfieLabel: payload.selfieLabel,
      notes: current.notes,
    );
    _records[index] = updated;
    return updated;
  }

  static bool _isCheckInLate({
    required DateTime now,
    required String workStartTime,
  }) {
    final parts = workStartTime.split(':');
    final startHour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 8 : 8;
    final startMinute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final threshold = DateTime(
      now.year,
      now.month,
      now.day,
      startHour,
      startMinute,
    );
    return now.isAfter(threshold);
  }

  static List<AttendanceRecordDto> _seedCurrentMonthRecords(DateTime now) {
    final seeded = <AttendanceRecordDto>[];
    var seedCounter = 0;

    for (var day = 1; day < now.day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }

      seedCounter++;
      if (seedCounter == 3) {
        seeded.add(
          AttendanceRecordDto(
            id: 'att-seed-$day',
            dateIso: date.toIso8601String(),
            statusName: AttendanceStatus.late.name,
            checkInTimeIso:
                DateTime(now.year, now.month, day, 8, 18).toIso8601String(),
            checkOutTimeIso:
                DateTime(now.year, now.month, day, 17, 5).toIso8601String(),
            checkInDistanceMeters: 38.0,
            checkOutDistanceMeters: 44.0,
            selfieLabel: 'selfie_seed_${day}_in.jpg',
            notes: 'Terlambat 18 menit karena kendala transportasi.',
          ),
        );
      } else if (seedCounter == 6) {
        seeded.add(
          AttendanceRecordDto(
            id: 'att-seed-$day',
            dateIso: date.toIso8601String(),
            statusName: AttendanceStatus.leave.name,
            notes: 'Izin mengikuti ujian praktikum di sekolah.',
          ),
        );
      } else if (seedCounter == 9) {
        seeded.add(
          AttendanceRecordDto(
            id: 'att-seed-$day',
            dateIso: date.toIso8601String(),
            statusName: AttendanceStatus.absent.name,
            notes: 'Tidak ada keterangan presensi.',
          ),
        );
      } else {
        final inMinute = 45 + (seedCounter % 12);
        final outMinute = 2 + (seedCounter % 15);
        seeded.add(
          AttendanceRecordDto(
            id: 'att-seed-$day',
            dateIso: date.toIso8601String(),
            statusName: AttendanceStatus.present.name,
            checkInTimeIso:
                DateTime(now.year, now.month, day, 7, inMinute).toIso8601String(),
            checkOutTimeIso: DateTime(now.year, now.month, day, 17, outMinute)
                .toIso8601String(),
            checkInDistanceMeters: 24.0 + (seedCounter * 3),
            checkOutDistanceMeters: 31.0 + (seedCounter * 2),
            selfieLabel: 'selfie_seed_${day}_in.jpg',
            notes: 'Hadir sesuai jadwal kerja DUDI.',
          ),
        );
      }
    }

    return seeded;
  }
}
