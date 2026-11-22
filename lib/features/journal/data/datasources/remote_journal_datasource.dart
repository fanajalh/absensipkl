import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/journal_validation_status.dart';
import '../models/journal_entry_dto.dart';
import 'journal_datasource.dart';

/// Production REST datasource communicating with `/siswa/journals`.
class RemoteJournalDatasource implements JournalDatasource {
  RemoteJournalDatasource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<JournalEntryDto>> getEntries() async {
    final response = await _apiClient.get(ApiPaths.journals);
    final data = _unwrapData(response);
    final rawList = (data['journals'] as List<dynamic>?) ??
        (data['entries'] as List<dynamic>?) ??
        const <dynamic>[];
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map(_parseJournal)
        .toList(growable: false);
    return items;
  }

  @override
  Future<JournalEntryDto> saveEntry(JournalEntryDto entry) async {
    final response = await _apiClient.post(
      ApiPaths.journals,
      body: <String, dynamic>{
        'title': entry.title,
        'description': entry.description,
        if (entry.photoUrl != null && entry.photoUrl!.isNotEmpty)
          'photoUrl': entry.photoUrl,
        'date': entry.dateIso,
        'startTime': entry.startTime,
        'endTime': entry.endTime,
      },
    );
    final data = _unwrapData(response);
    final item = (data['journal'] as Map<String, dynamic>?) ??
        (data['entry'] as Map<String, dynamic>?) ??
        data;
    if (item.isEmpty || !item.containsKey('title')) {
      return entry;
    }
    return _parseJournal(item);
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> response) {
    final nested = response['data'];
    if (nested is Map<String, dynamic>) return nested;
    return response;
  }

  JournalEntryDto _parseJournal(Map<String, dynamic> json) {
    final rawStatus =
        (json['status'] ?? json['statusName'] ?? 'pending').toString();
    return JournalEntryDto(
      id: (json['id'] ?? '').toString(),
      dateIso: (json['date'] ??
              json['dateIso'] ??
              json['createdAt'] ??
              DateTime.now().toIso8601String())
          .toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      startTime: (json['startTime'] ?? '08:00').toString(),
      endTime: (json['endTime'] ?? '17:00').toString(),
      statusName: _mapStatus(rawStatus).name,
      photoUrl: json['photoUrl'] as String?,
      mentorNote: (json['mentorNote'] ?? json['note']) as String?,
    );
  }

  JournalValidationStatus _mapStatus(String raw) {
    final upper = raw.trim().toUpperCase();
    return switch (upper) {
      'DISETUJUI' || 'APPROVED' => JournalValidationStatus.approved,
      'REVISI' || 'REVISION' || 'PERLU_REVISI' =>
        JournalValidationStatus.revision,
      _ => JournalValidationStatus.pending,
    };
  }
}
