// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorageDatasource)
final secureStorageDatasourceProvider = SecureStorageDatasourceProvider._();

final class SecureStorageDatasourceProvider
    extends
        $FunctionalProvider<
          SecureStorageDatasource,
          SecureStorageDatasource,
          SecureStorageDatasource
        >
    with $Provider<SecureStorageDatasource> {
  SecureStorageDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageDatasourceHash();

  @$internal
  @override
  $ProviderElement<SecureStorageDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageDatasource create(Ref ref) {
    return secureStorageDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageDatasource>(value),
    );
  }
}

String _$secureStorageDatasourceHash() =>
    r'2d6d568e1ceb8d99d32426c8bb73d0ca5434536f';
