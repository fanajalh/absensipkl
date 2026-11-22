// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(historyDatasource)
final historyDatasourceProvider = HistoryDatasourceProvider._();

final class HistoryDatasourceProvider
    extends
        $FunctionalProvider<
          HistoryDatasource,
          HistoryDatasource,
          HistoryDatasource
        >
    with $Provider<HistoryDatasource> {
  HistoryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyDatasourceHash();

  @$internal
  @override
  $ProviderElement<HistoryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HistoryDatasource create(Ref ref) {
    return historyDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryDatasource>(value),
    );
  }
}

String _$historyDatasourceHash() => r'3a411bcb5ce5378dfdb6fa25a69907be0c22ef4d';

@ProviderFor(historyRepository)
final historyRepositoryProvider = HistoryRepositoryProvider._();

final class HistoryRepositoryProvider
    extends
        $FunctionalProvider<
          HistoryRepository,
          HistoryRepository,
          HistoryRepository
        >
    with $Provider<HistoryRepository> {
  HistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyRepositoryHash();

  @$internal
  @override
  $ProviderElement<HistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HistoryRepository create(Ref ref) {
    return historyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryRepository>(value),
    );
  }
}

String _$historyRepositoryHash() => r'0b254805fac520c29628afb97ec34e3b447c1a17';
