import '../../../../core/constants/api_paths.dart';
import '../../../../core/errors/app_error.dart';
import '../models/auth_session_dto.dart';
import '../models/dudi_placement_dto.dart';
import '../models/student_profile_dto.dart';
import 'auth_datasource.dart';

/// Non-secret offline fixture datasource for MVP & QA evaluation.
class DemoAuthDatasource implements AuthDatasource {
  static const String demoNisn = '0078451920';
  static const String demoEmail = 'rafi.pratama@smkfanajalh.sch.id';
  static const String demoPasscode = 'pkl2026';

  static const StudentProfileDto _demoStudent = StudentProfileDto(
    id: 'std-2026-001',
    nisn: demoNisn,
    fullName: 'Rafi Pratama Putra',
    className: 'XII RPL 2',
    major: 'Rekayasa Perangkat Lunak',
    email: demoEmail,
    placement: DudiPlacementDto(
      id: 'dudi-001',
      companyName: 'PT Fanajalh Digital Indonesia',
      address: 'Jl. HR Rasuna Said Kav. 12, Jakarta Selatan',
      mentorName: 'Budi Santoso, S.Kom.',
      latitude: ApiPaths.defaultDudiLatitude,
      longitude: ApiPaths.defaultDudiLongitude,
      allowedRadiusMeters: ApiPaths.defaultAllowedRadiusMeters,
      workStartTime: ApiPaths.defaultWorkStart,
      workEndTime: ApiPaths.defaultWorkEnd,
    ),
  );

  @override
  Future<AuthSessionDto> login({
    required String identifier,
    required String password,
  }) async {
    final normalizedId = identifier.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (normalizedId.isEmpty || trimmedPassword.isEmpty) {
      throw const AppError.validation(
        message: 'NISN/Email dan kata sandi wajib diisi.',
      );
    }

    final isValidUser = normalizedId == demoNisn || normalizedId == demoEmail;
    if (!isValidUser || trimmedPassword != demoPasscode) {
      throw const AppError.unauthorized(
        message: 'NISN/Email atau kata sandi tidak sesuai.',
      );
    }

    final now = DateTime.now();
    return AuthSessionDto(
      accessToken: 'demo_session_${now.millisecondsSinceEpoch}',
      issuedAtIso: now.toIso8601String(),
      expiresAtIso: now.add(const Duration(days: 7)).toIso8601String(),
      student: _demoStudent,
    );
  }

  @override
  Future<void> logout() async {}
}
