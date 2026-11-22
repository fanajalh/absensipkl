// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journalDatasource)
final journalDatasourceProvider = JournalDatasourceProvider._();

final class JournalDatasourceProvider
    extends
        $FunctionalProvider<
          JournalDatasource,
          JournalDatasource,
          JournalDatasource
        >
    with $Provider<JournalDatasource> {
  JournalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalDatasourceHash();

  @$internal
  @override
  $ProviderElement<JournalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JournalDatasource create(Ref ref) {
    return journalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalDatasource>(value),
    );
  }
}

String _$journalDatasourceHash() => r'731d9020dae8ffda27e66206cbc7731d9a81cd09';

@ProviderFor(journalRepository)
final journalRepositoryProvider = JournalRepositoryProvider._();

final class JournalRepositoryProvider
    extends
        $FunctionalProvider<
          JournalRepository,
          JournalRepository,
          JournalRepository
        >
    with $Provider<JournalRepository> {
  JournalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalRepositoryHash();

  @$internal
  @override
  $ProviderElement<JournalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JournalRepository create(Ref ref) {
    return journalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JournalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JournalRepository>(value),
    );
  }
}

String _$journalRepositoryHash() => r'd7d81fc1c1e44d06ae66eabaec16bff8ccd2baa5';
