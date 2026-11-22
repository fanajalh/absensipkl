import '../../../../core/constants/api_paths.dart';
import '../../../auth/data/models/dudi_placement_dto.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/siswa_home_snapshot.dart';
import 'announcement_dto.dart';
import 'attendance_record_dto.dart';

/// DTO parsing `/siswa/home` nested payload.
class SiswaHomeDto {
  const SiswaHomeDto({
    this.placement,
    this.todayRecord,
    this.approvedJournalsCount = 0,
    this.targetDays = 120,
    this.announcements = const <AnnouncementDto>[],
  });

  factory SiswaHomeDto.fromJson(Map<String, dynamic> json) {
    final placementRaw = json['placement'] as Map<String, dynamic>?;
    final todayRaw = json['todayAttendance'] as Map<String, dynamic>?;
    final announcementsRaw = json['announcements'] as List<dynamic>?;

    return SiswaHomeDto(
      placement:
          placementRaw == null ? null : _parsePlacement(placementRaw),
      todayRecord: todayRaw == null ? null : parseAttendanceJson(todayRaw),
      approvedJournalsCount:
          (json['approvedJournals'] as num?)?.toInt() ?? 0,
      targetDays: ((placementRaw?['period'] as Map<String, dynamic>?)?['targetDays']
                  as num?)
              ?.toInt() ??
          120,
      announcements: announcementsRaw == null
          ? const <AnnouncementDto>[]
          : announcementsRaw
              .whereType<Map<String, dynamic>>()
              .map(AnnouncementDto.fromJson)
              .toList(growable: false),
    );
  }

  final DudiPlacementDto? placement;
  final AttendanceRecordDto? todayRecord;
  final int approvedJournalsCount;
  final int targetDays;
  final List<AnnouncementDto> announcements;

  SiswaHomeSnapshot toEntity() => SiswaHomeSnapshot(
        placement: placement?.toEntity(),
        todayRecord: todayRecord?.toEntity(),
        approvedJournalsCount: approvedJournalsCount,
        targetDays: targetDays,
        announcements:
            announcements.map((dto) => dto.toEntity()).toList(growable: false),
      );

  static DudiPlacementDto _parsePlacement(Map<String, dynamic> placement) {
    final industry =
        (placement['industry'] as Map<String, dynamic>?) ?? placement;
    final teacher = placement['teacher'] as Map<String, dynamic>?;
    final mentorName =
        (industry['mentorName'] ?? teacher?['name'] ?? 'Pembimbing DUDI')
            .toString();

    return DudiPlacementDto(
      id: (placement['id'] ?? industry['id'] ?? 'dudi-001').toString(),
      companyName:
          (industry['name'] ?? industry['companyName'] ?? 'DUDI Penempatan')
              .toString(),
      address: (industry['address'] ?? '-').toString(),
      mentorName: mentorName,
      latitude: (industry['latitude'] as num?)?.toDouble() ??
          ApiPaths.defaultDudiLatitude,
      longitude: (industry['longitude'] as num?)?.toDouble() ??
          ApiPaths.defaultDudiLongitude,
      allowedRadiusMeters:
          (industry['radiusMeters'] as num?)?.toDouble() ??
              (industry['allowedRadiusMeters'] as num?)?.toDouble() ??
              ApiPaths.defaultAllowedRadiusMeters,
      workStartTime:
          (industry['workStartTime'] ?? ApiPaths.defaultWorkStart).toString(),
      workEndTime:
          (industry['workEndTime'] ?? ApiPaths.defaultWorkEnd).toString(),
    );
  }

  /// Parses flexible backend attendance object into [AttendanceRecordDto].
  static AttendanceRecordDto parseAttendanceJson(Map<String, dynamic> json) {
    final rawStatus =
        (json['status'] ?? json['statusName'] ?? 'present').toString();
    final mappedStatus = _mapStatusName(rawStatus);
    final checkInRaw =
        (json['checkInTime'] ?? json['checkInTimeIso']) as String?;
    final checkOutRaw =
        (json['checkOutTime'] ?? json['checkOutTimeIso']) as String?;
    final dateRaw =
        (json['date'] ?? json['dateIso'] ?? checkInRaw ?? DateTime.now().toIso8601String())
            .toString();

    return AttendanceRecordDto(
      id: (json['id'] ?? 'att-live').toString(),
      dateIso: dateRaw,
      statusName: mappedStatus.name,
      checkInTimeIso: checkInRaw,
      checkOutTimeIso: checkOutRaw,
      checkInDistanceMeters:
          (json['checkInDistanceMeters'] ?? json['distanceMeters'] as num?)
              ?.toDouble(),
      checkOutDistanceMeters:
          (json['checkOutDistanceMeters'] as num?)?.toDouble(),
      isMockLocationFlagged: (json['isMockGps'] as bool?) ??
          (json['isMockLocationFlagged'] as bool?) ??
          false,
      selfieLabel: (json['selfieUrl'] ?? json['selfieLabel']) as String?,
      notes: json['notes'] as String?,
    );
  }

  static AttendanceStatus _mapStatusName(String raw) {
    final normalized = raw.trim().toUpperCase();
    return switch (normalized) {
      'HADIR' || 'PRESENT' => AttendanceStatus.present,
      'TERLAMBAT' || 'TELAT' || 'LATE' => AttendanceStatus.late,
      'IZIN' || 'SAKIT' || 'LEAVE' => AttendanceStatus.leave,
      'ALPHA' || 'ABSENT' => AttendanceStatus.absent,
      _ => AttendanceStatus.present,
    };
  }
}
