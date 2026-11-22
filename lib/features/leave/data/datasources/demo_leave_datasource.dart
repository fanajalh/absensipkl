import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_type.dart';
import '../models/leave_request_dto.dart';
import 'leave_datasource.dart';

/// In-memory seeded leave request datasource for MVP.
class DemoLeaveDatasource implements LeaveDatasource {
  DemoLeaveDatasource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now {
    _requests.addAll(_seedRequests(_clock()));
  }

  final DateTime Function() _clock;
  final List<LeaveRequestDto> _requests = <LeaveRequestDto>[];

  @override
  Future<List<LeaveRequestDto>> getRequests() async {
    final sorted = List<LeaveRequestDto>.of(_requests)
      ..sort(
        (a, b) => DateTime.parse(b.submittedAtIso)
            .compareTo(DateTime.parse(a.submittedAtIso)),
      );
    return List<LeaveRequestDto>.unmodifiable(sorted);
  }

  @override
  Future<LeaveRequestDto> submitRequest(LeaveRequestDto request) async {
    final now = _clock();
    final created = LeaveRequestDto(
      id: request.id.isEmpty ? 'lv-${now.millisecondsSinceEpoch}' : request.id,
      typeName: request.typeName,
      startDateIso: request.startDateIso,
      endDateIso: request.endDateIso,
      reason: request.reason,
      attachmentName: request.attachmentName,
      statusName: LeaveApprovalStatus.submitted.name,
      submittedAtIso: now.toIso8601String(),
    );
    _requests.insert(0, created);
    return created;
  }

  static List<LeaveRequestDto> _seedRequests(DateTime now) {
    final d1 = now.subtract(const Duration(days: 6));
    final d2 = now.subtract(const Duration(days: 1));
    return <LeaveRequestDto>[
      LeaveRequestDto(
        id: 'lv-seed-001',
        typeName: LeaveType.izin.name,
        startDateIso: DateTime(d1.year, d1.month, d1.day).toIso8601String(),
        endDateIso: DateTime(d1.year, d1.month, d1.day).toIso8601String(),
        reason: 'Mengikuti ujian praktikum kejuruan di SMK.',
        attachmentName: 'surat_tugas_ujian_smk.pdf',
        statusName: LeaveApprovalStatus.approved.name,
        submittedAtIso: d1.subtract(const Duration(days: 1)).toIso8601String(),
      ),
      LeaveRequestDto(
        id: 'lv-seed-002',
        typeName: LeaveType.sakit.name,
        startDateIso: DateTime(d2.year, d2.month, d2.day).toIso8601String(),
        endDateIso: DateTime(d2.year, d2.month, d2.day).toIso8601String(),
        reason: 'Demam ringan, istirahat sesuai anjuran dokter klinik.',
        attachmentName: 'surat_dokter_klinik.jpg',
        statusName: LeaveApprovalStatus.submitted.name,
        submittedAtIso: d2.toIso8601String(),
      ),
    ];
  }
}
