// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LeaveNotifier)
final leaveProvider = LeaveNotifierProvider._();

final class LeaveNotifierProvider
    extends $AsyncNotifierProvider<LeaveNotifier, List<LeaveRequest>> {
  LeaveNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveNotifierHash();

  @$internal
  @override
  LeaveNotifier create() => LeaveNotifier();
}

String _$leaveNotifierHash() => r'5112c4c9ed0c5ff3fb02486a50b6f3bcd2379fa9';

abstract class _$LeaveNotifier extends $AsyncNotifier<List<LeaveRequest>> {
  FutureOr<List<LeaveRequest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LeaveRequest>>, List<LeaveRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LeaveRequest>>, List<LeaveRequest>>,
              AsyncValue<List<LeaveRequest>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
