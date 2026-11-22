import '../../domain/entities/announcement.dart';

/// DTO parsing `/siswa/home` announcement payload.
class AnnouncementDto {
  const AnnouncementDto({
    required this.id,
    required this.title,
    required this.content,
    required this.targetRole,
    required this.createdAtIso,
  });

  factory AnnouncementDto.fromJson(Map<String, dynamic> json) => AnnouncementDto(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? 'Pengumuman').toString(),
        content: (json['content'] ?? '').toString(),
        targetRole: (json['targetRole'] ?? 'SISWA').toString(),
        createdAtIso: (json['createdAt'] ??
                json['createdAtIso'] ??
                DateTime.now().toIso8601String())
            .toString(),
      );

  final String id;
  final String title;
  final String content;
  final String targetRole;
  final String createdAtIso;

  Announcement toEntity() => Announcement(
        id: id,
        title: title,
        content: content,
        targetRole: targetRole,
        createdAt: DateTime.tryParse(createdAtIso) ?? DateTime.now(),
      );
}
