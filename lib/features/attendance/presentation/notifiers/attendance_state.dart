import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/services/location_datasource.dart';
import '../../../auth/domain/entities/dudi_placement.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/geofence_evaluation.dart';

part 'attendance_state.freezed.dart';

/// Immutable snapshot of the Presensi Home dashboard state.
@freezed
abstract class AttendanceDashboardState with _$AttendanceDashboardState {
  const factory AttendanceDashboardState({
    DudiPlacement? placement,
    AttendanceRecord? todayRecord,
    GeofenceEvaluation? geofence,
    @Default(0) int approvedJournalsCount,
    @Default(120) int targetDays,
    @Default(<Announcement>[]) List<Announcement> announcements,
    @Default(false) bool isRefreshingLocation,
    @Default(false) bool isSubmitting,
    @Default(DemoLocationPreset.insideRadius) DemoLocationPreset demoPreset,
    @Default(false) bool supportsDemoPreset,
    AppError? actionError,
    String? actionSuccessMessage,
  }) = _AttendanceDashboardState;
}
