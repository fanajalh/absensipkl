import '../../../../core/constants/api_paths.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_session_dto.dart';
import '../models/dudi_placement_dto.dart';
import '../models/student_profile_dto.dart';
import 'auth_datasource.dart';

/// Production REST datasource communicating with `/auth/login` and `/auth/me`.
class RemoteAuthDatasource implements AuthDatasource {
  RemoteAuthDatasource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSessionDto> login({
    required String identifier,
    required String password,
  }) async {
    final normalizedId = identifier.trim();
    final trimmedPassword = password.trim();

    if (normalizedId.isEmpty || trimmedPassword.isEmpty) {
      throw const AppError.validation(
        message: 'NISN/Email dan kata sandi wajib diisi.',
      );
    }

    final response = await _apiClient.post(
      ApiPaths.login,
      body: <String, dynamic>{
        'identifier': normalizedId,
        'password': trimmedPassword,
        'deviceId': 'flutter_client',
      },
    );

    final data = _unwrapData(response);
    final token = (data['token'] ?? data['accessToken']) as String?;
    final userMap = data['user'] as Map<String, dynamic>?;
    if (token == null || token.isEmpty || userMap == null) {
      throw const AppError.unexpected(
        message: 'Respon login server tidak valid.',
      );
    }

    final now = DateTime.now();
    return AuthSessionDto(
      accessToken: token,
      issuedAtIso: now.toIso8601String(),
      expiresAtIso: now.add(const Duration(days: 7)).toIso8601String(),
      student: _parseStudent(userMap),
    );
  }

  Future<StudentProfileDto> fetchMe() async {
    final response = await _apiClient.get(ApiPaths.me);
    final data = _unwrapData(response);
    final userMap =
        (data['user'] as Map<String, dynamic>?) ?? data;
    return _parseStudent(userMap);
  }

  @override
  Future<void> logout() async {}

  Map<String, dynamic> _unwrapData(Map<String, dynamic> response) {
    final nested = response['data'];
    if (nested is Map<String, dynamic>) return nested;
    return response;
  }

  StudentProfileDto _parseStudent(Map<String, dynamic> user) {
    final placementJson = user['placement'] as Map<String, dynamic>?;
    return StudentProfileDto(
      id: (user['id'] ?? '').toString(),
      nisn: (user['nisn'] ?? '').toString(),
      fullName: (user['name'] ?? user['fullName'] ?? 'Siswa PKL').toString(),
      className: (user['className'] ?? 'XII PKL').toString(),
      major: (user['major'] ?? user['role'] ?? 'PKL').toString(),
      email: (user['email'] ?? '').toString(),
      placement: placementJson != null
          ? DudiPlacementDto.fromJson(placementJson)
          : const DudiPlacementDto(
              id: 'dudi-default',
              companyName: 'DUDI Penempatan',
              address: 'Alamat DUDI',
              mentorName: 'Pembimbing DUDI',
              latitude: ApiPaths.defaultDudiLatitude,
              longitude: ApiPaths.defaultDudiLongitude,
              allowedRadiusMeters: ApiPaths.defaultAllowedRadiusMeters,
              workStartTime: ApiPaths.defaultWorkStart,
              workEndTime: ApiPaths.defaultWorkEnd,
            ),
    );
  }
}
