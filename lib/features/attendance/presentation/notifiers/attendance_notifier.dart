import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/services/camera_datasource.dart';
import '../../../../core/services/location_datasource.dart';
import '../../../auth/domain/entities/dudi_placement.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../history/presentation/notifiers/history_notifier.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/entities/geofence_evaluation.dart';
import '../../repositories/attendance_repository_impl.dart';
import 'attendance_state.dart';

part 'attendance_notifier.g.dart';

@riverpod
class AttendanceNotifier extends _$AttendanceNotifier {
  @override
  Future<AttendanceDashboardState> build() async {
    final authState = ref.watch(authProvider);
    var placement = switch (authState) {
      AuthAuthenticated(:final session) => session.student.placement,
      _ => null,
    };

    final locationDs = ref.watch(locationDatasourceProvider);
    final repo = ref.watch(attendanceRepositoryProvider);

    final summary = await repo.getHomeSummary();
    if (!ref.mounted) {
      return const AttendanceDashboardState();
    }

    final todayRecord = summary?.todayRecord ?? await repo.getTodayRecord();
    if (!ref.mounted) {
      return const AttendanceDashboardState();
    }

    if (summary?.placement != null && summary!.placement != placement) {
      placement = summary.placement;
      Future<void>.microtask(() {
        if (ref.mounted) {
          ref.read(authProvider.notifier).syncPlacement(placement!);
        }
      });
    }

    GeofenceEvaluation? geofence;
    AppError? initialError;
    if (placement != null) {
      try {
        geofence = await repo.evaluateGeofence(
          targetLat: placement.latitude,
          targetLng: placement.longitude,
          allowedRadiusMeters: placement.allowedRadiusMeters,
        );
      } catch (error) {
        initialError = AppErrorMapper.fromObject(error);
      }
      if (!ref.mounted) {
        return const AttendanceDashboardState();
      }
    }

    return AttendanceDashboardState(
      placement: placement,
      todayRecord: todayRecord,
      geofence: geofence,
      approvedJournalsCount: summary?.approvedJournalsCount ?? 0,
      targetDays: summary?.targetDays ?? 120,
      announcements: summary?.announcements ?? const <Announcement>[],
      demoPreset: locationDs.currentPreset,
      supportsDemoPreset: locationDs.isSimulationSupported,
      actionError: initialError,
    );
  }

  DudiPlacement? _currentPlacement() {
    final fromState = state.asData?.value.placement;
    if (fromState != null) return fromState;
    final authState = ref.read(authProvider);
    return switch (authState) {
      AuthAuthenticated(:final session) => session.student.placement,
      _ => null,
    };
  }

  Future<void> refreshLocation() async {
    final current = state.asData?.value;
    final placement = _currentPlacement();
    if (current == null || placement == null) return;

    state = AsyncData(
      current.copyWith(
        isRefreshingLocation: true,
        actionError: null,
        actionSuccessMessage: null,
      ),
    );

    try {
      final geofence = await ref
          .read(attendanceRepositoryProvider)
          .evaluateGeofence(
            targetLat: placement.latitude,
            targetLng: placement.longitude,
            allowedRadiusMeters: placement.allowedRadiusMeters,
          );
      if (!ref.mounted) return;
      final latest = state.asData?.value ?? current;
      state = AsyncData(
        latest.copyWith(
          geofence: geofence,
          isRefreshingLocation: false,
          demoPreset: ref.read(locationDatasourceProvider).currentPreset,
          actionError: null,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      final latest = state.asData?.value ?? current;
      state = AsyncData(
        latest.copyWith(
          isRefreshingLocation: false,
          actionError: AppErrorMapper.fromObject(error),
        ),
      );
    }
  }

  Future<void> setDemoPreset(DemoLocationPreset preset) async {
    ref.read(locationDatasourceProvider).setDemoPreset(preset);
    await refreshLocation();
  }

  /// Validates fresh GPS + anti-mock-GPS rules without opening camera yet.
  Future<GeofenceEvaluation?> validateGeofenceForSelfie() async {
    final current = state.asData?.value;
    final placement = _currentPlacement();
    if (current == null || placement == null) return null;

    state = AsyncData(
      current.copyWith(
        isRefreshingLocation: true,
        actionError: null,
        actionSuccessMessage: null,
      ),
    );

    try {
      final evaluation = await ref
          .read(attendanceRepositoryProvider)
          .evaluateGeofence(
            targetLat: placement.latitude,
            targetLng: placement.longitude,
            allowedRadiusMeters: placement.allowedRadiusMeters,
          );
      if (!ref.mounted) return null;

      if (evaluation.isMocked) {
        state = AsyncData(
          current.copyWith(
            geofence: evaluation,
            isRefreshingLocation: false,
            actionError: const AppError.mockLocationDetected(
              message:
                  'Lokasi palsu (Fake GPS) terdeteksi. Nonaktifkan aplikasi lokasi tiruan sebelum presensi.',
            ),
          ),
        );
        return null;
      }

      if (!evaluation.isWithinRadius) {
        state = AsyncData(
          current.copyWith(
            geofence: evaluation,
            isRefreshingLocation: false,
            actionError: AppError.outOfGeofence(
              distanceMeters: evaluation.distanceMeters,
              radiusMeters: evaluation.allowedRadiusMeters,
            ),
          ),
        );
        return null;
      }

      state = AsyncData(
        current.copyWith(
          geofence: evaluation,
          isRefreshingLocation: false,
          actionError: null,
        ),
      );
      return evaluation;
    } catch (error) {
      if (!ref.mounted) return null;
      final latest = state.asData?.value ?? current;
      state = AsyncData(
        latest.copyWith(
          isRefreshingLocation: false,
          actionError: AppErrorMapper.fromObject(error),
        ),
      );
      return null;
    }
  }

  /// Evaluates fresh GPS + anti-mock-GPS rules and triggers camera-only selfie.
  Future<({CapturedSelfie selfie, GeofenceEvaluation geofence})?>
      prepareAttendanceSelfie() async {
    final evaluation = await validateGeofenceForSelfie();
    if (!ref.mounted || evaluation == null) return null;

    final current = state.asData?.value;
    try {
      final selfie = await ref.read(cameraDatasourceProvider).captureSelfie();
      if (!ref.mounted || selfie == null) return null;

      return (selfie: selfie, geofence: evaluation);
    } catch (error) {
      if (!ref.mounted || current == null) return null;
      state = AsyncData(
        current.copyWith(
          isRefreshingLocation: false,
          actionError: AppErrorMapper.fromObject(error),
        ),
      );
      return null;
    }
  }

  Future<bool> submitAttendance({
    required CapturedSelfie selfie,
    required GeofenceEvaluation geofence,
  }) async {
    final current = state.asData?.value;
    final placement = _currentPlacement();
    if (current == null || placement == null) return false;

    state = AsyncData(
      current.copyWith(
        isSubmitting: true,
        actionError: null,
        actionSuccessMessage: null,
      ),
    );

    try {
      final repo = ref.read(attendanceRepositoryProvider);
      final isCheckOut = current.todayRecord?.hasCheckedIn ?? false;

      final updatedRecord = isCheckOut
          ? await repo.submitCheckOut(
              location: geofence.location,
              distanceMeters: geofence.distanceMeters,
              allowedRadiusMeters: placement.allowedRadiusMeters,
              selfieLabel: selfie.storageValue,
            )
          : await repo.submitCheckIn(
              location: geofence.location,
              distanceMeters: geofence.distanceMeters,
              allowedRadiusMeters: placement.allowedRadiusMeters,
              selfieLabel: selfie.storageValue,
              workStartTime: placement.workStartTime,
            );

      if (!ref.mounted) return false;

      final latest = state.asData?.value ?? current;
      state = AsyncData(
        latest.copyWith(
          todayRecord: updatedRecord,
          geofence: geofence,
          isSubmitting: false,
          actionError: null,
          actionSuccessMessage: isCheckOut
              ? 'Check-Out berhasil dicatat.'
              : 'Check-In berhasil dicatat.',
        ),
      );
      ref.invalidate(historyProvider);
      return true;
    } catch (error) {
      if (!ref.mounted) return false;
      final latest = state.asData?.value ?? current;
      state = AsyncData(
        latest.copyWith(
          isSubmitting: false,
          actionError: AppErrorMapper.fromObject(error),
        ),
      );
      return false;
    }
  }

  void clearBanner() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        actionError: null,
        actionSuccessMessage: null,
      ),
    );
  }
}
