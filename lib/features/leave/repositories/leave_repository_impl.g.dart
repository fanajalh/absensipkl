// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(leaveDatasource)
final leaveDatasourceProvider = LeaveDatasourceProvider._();

final class LeaveDatasourceProvider
    extends
        $FunctionalProvider<LeaveDatasource, LeaveDatasource, LeaveDatasource>
    with $Provider<LeaveDatasource> {
  LeaveDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveDatasourceHash();

  @$internal
  @override
  $ProviderElement<LeaveDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveDatasource create(Ref ref) {
    return leaveDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveDatasource>(value),
    );
  }
}

String _$leaveDatasourceHash() => r'b3157034aaf880775dc931add121a401468cfce9';

@ProviderFor(leaveRepository)
final leaveRepositoryProvider = LeaveRepositoryProvider._();

final class LeaveRepositoryProvider
    extends
        $FunctionalProvider<LeaveRepository, LeaveRepository, LeaveRepository>
    with $Provider<LeaveRepository> {
  LeaveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveRepositoryHash();

  @$internal
  @override
  $ProviderElement<LeaveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveRepository create(Ref ref) {
    return leaveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveRepository>(value),
    );
  }
}

String _$leaveRepositoryHash() => r'b57309d7480a387988ba3dab03b4151e8c4941d7';
