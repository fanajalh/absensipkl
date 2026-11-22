import '../../domain/entities/journal_validation_status.dart';
import '../models/journal_entry_dto.dart';
import 'journal_datasource.dart';

/// In-memory seeded PKL activity logbook datasource for MVP.
class DemoJournalDatasource implements JournalDatasource {
  DemoJournalDatasource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now {
    _entries.addAll(_seedEntries(_clock()));
  }

  final DateTime Function() _clock;
  final List<JournalEntryDto> _entries = <JournalEntryDto>[];

  @override
  Future<List<JournalEntryDto>> getEntries() async {
    final sorted = List<JournalEntryDto>.of(_entries)
      ..sort(
        (a, b) => DateTime.parse(b.dateIso).compareTo(DateTime.parse(a.dateIso)),
      );
    return List<JournalEntryDto>.unmodifiable(sorted);
  }

  @override
  Future<JournalEntryDto> saveEntry(JournalEntryDto entry) async {
    final normalizedId =
        entry.id.isEmpty ? 'jrn-${_clock().millisecondsSinceEpoch}' : entry.id;
    final saved = JournalEntryDto(
      id: normalizedId,
      dateIso: entry.dateIso,
      title: entry.title,
      description: entry.description,
      startTime: entry.startTime,
      endTime: entry.endTime,
      statusName: entry.id.isEmpty
          ? JournalValidationStatus.pending.name
          : entry.statusName,
      mentorNote: entry.mentorNote,
    );

    final index = _entries.indexWhere((e) => e.id == normalizedId);
    if (index == -1) {
      _entries.insert(0, saved);
    } else {
      _entries[index] = saved;
    }
    return saved;
  }

  static List<JournalEntryDto> _seedEntries(DateTime now) {
    final d1 = now.subtract(const Duration(days: 1));
    final d2 = now.subtract(const Duration(days: 2));
    final d3 = now.subtract(const Duration(days: 4));

    return <JournalEntryDto>[
      JournalEntryDto(
        id: 'jrn-seed-001',
        dateIso: DateTime(d1.year, d1.month, d1.day).toIso8601String(),
        title: 'Integrasi Endpoint REST Modul Karyawan',
        description:
            'Membuat DTO serialisasi JSON, memetakan ke entitas domain, dan menulis unit test parsing payload API.',
        startTime: '08:30',
        endTime: '16:45',
        statusName: JournalValidationStatus.pending.name,
      ),
      JournalEntryDto(
        id: 'jrn-seed-002',
        dateIso: DateTime(d2.year, d2.month, d2.day).toIso8601String(),
        title: 'Perbaikan Validasi Form Input Data DUDI',
        description:
            'Menambahkan pengecekan panjang karakter dan format koordinat agar data lokasi tidak gagal saat disimpan.',
        startTime: '08:15',
        endTime: '17:00',
        statusName: JournalValidationStatus.approved.name,
        mentorNote: 'Struktur validasi sudah rapi dan sesuai standar tim.',
      ),
      JournalEntryDto(
        id: 'jrn-seed-003',
        dateIso: DateTime(d3.year, d3.month, d3.day).toIso8601String(),
        title: 'Pembuatan Halaman Rekap Presensi Mingguan',
        description:
            'Menyusun komponen kartu ringkasan KPI serta filter status kehadiran pada dashboard siswa.',
        startTime: '09:00',
        endTime: '16:30',
        statusName: JournalValidationStatus.revision.name,
        mentorNote: 'Lengkapi penjelasan output komponen UI yang dihasilkan.',
      ),
    ];
  }
}
