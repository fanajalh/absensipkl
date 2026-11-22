// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AttendanceNotifier)
final attendanceProvider = AttendanceNotifierProvider._();

final class AttendanceNotifierProvider
    extends
        $AsyncNotifierProvider<AttendanceNotifier, AttendanceDashboardState> {
  AttendanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceNotifierHash();

  @$internal
  @override
  AttendanceNotifier create() => AttendanceNotifier();
}

String _$attendanceNotifierHash() =>
    r'a11beba65e66c820d01671ebf87343d67beb3ec6';

abstract class _$AttendanceNotifier
    extends $AsyncNotifier<AttendanceDashboardState> {
  FutureOr<AttendanceDashboardState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AttendanceDashboardState>,
              AttendanceDashboardState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AttendanceDashboardState>,
                AttendanceDashboardState
              >,
              AsyncValue<AttendanceDashboardState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
