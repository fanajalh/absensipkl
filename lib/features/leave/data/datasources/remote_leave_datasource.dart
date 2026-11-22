import '../../../../core/constants/api_paths.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/leave_approval_status.dart';
import '../../domain/entities/leave_type.dart';
import '../models/leave_request_dto.dart';
import 'leave_datasource.dart';

/// Production REST datasource communicating with `/siswa/leaves`.
class RemoteLeaveDatasource implements LeaveDatasource {
  RemoteLeaveDatasource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<LeaveRequestDto>> getRequests() async {
    final response = await _apiClient.get(ApiPaths.leaves);
    final data = _unwrapData(response);
    final rawList = (data['leaves'] as List<dynamic>?) ??
        (data['requests'] as List<dynamic>?) ??
        const <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(_parseLeave)
        .toList(growable: false);
  }

  @override
  Future<LeaveRequestDto> submitRequest(LeaveRequestDto request) async {
    final response = await _apiClient.post(
      ApiPaths.leaves,
      body: <String, dynamic>{
        'type': request.typeName.toUpperCase(),
        'startDate': request.startDateIso,
        'endDate': request.endDateIso,
        'reason': request.reason,
        if (request.attachmentName != null &&
            request.attachmentName!.isNotEmpty)
          'attachmentUrl': request.attachmentName,
      },
    );
    final data = _unwrapData(response);
    final item = (data['leave'] as Map<String, dynamic>?) ??
        (data['request'] as Map<String, dynamic>?) ??
        data;
    if (item.isEmpty || !item.containsKey('reason')) {
      return request;
    }
    return _parseLeave(item);
  }

  Map<String, dynamic> _unwrapData(Map<String, dynamic> response) {
    final nested = response['data'];
    if (nested is Map<String, dynamic>) return nested;
    return response;
  }

  LeaveRequestDto _parseLeave(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? json['typeName'] ?? 'IZIN').toString();
    final rawStatus =
        (json['status'] ?? json['statusName'] ?? 'submitted').toString();
    return LeaveRequestDto(
      id: (json['id'] ?? '').toString(),
      typeName: _mapType(rawType).name,
      startDateIso: (json['startDate'] ??
              json['startDateIso'] ??
              DateTime.now().toIso8601String())
          .toString(),
      endDateIso: (json['endDate'] ??
              json['endDateIso'] ??
              DateTime.now().toIso8601String())
          .toString(),
      reason: (json['reason'] ?? '').toString(),
      attachmentName:
          (json['attachmentUrl'] ?? json['attachmentName']) as String?,
      statusName: _mapStatus(rawStatus).name,
      submittedAtIso: (json['createdAt'] ??
              json['submittedAtIso'] ??
              DateTime.now().toIso8601String())
          .toString(),
    );
  }

  LeaveType _mapType(String raw) {
    return switch (raw.trim().toUpperCase()) {
      'SAKIT' => LeaveType.sakit,
      _ => LeaveType.izin,
    };
  }

  LeaveApprovalStatus _mapStatus(String raw) {
    return switch (raw.trim().toUpperCase()) {
      'DISETUJUI' || 'APPROVED' => LeaveApprovalStatus.approved,
      'DITOLAK' || 'REJECTED' => LeaveApprovalStatus.rejected,
      _ => LeaveApprovalStatus.submitted,
    };
  }
}
