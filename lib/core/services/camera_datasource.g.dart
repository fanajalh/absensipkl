// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cameraDatasource)
final cameraDatasourceProvider = CameraDatasourceProvider._();

final class CameraDatasourceProvider
    extends
        $FunctionalProvider<
          CameraDatasource,
          CameraDatasource,
          CameraDatasource
        >
    with $Provider<CameraDatasource> {
  CameraDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraDatasourceHash();

  @$internal
  @override
  $ProviderElement<CameraDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CameraDatasource create(Ref ref) {
    return cameraDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraDatasource>(value),
    );
  }
}

String _$cameraDatasourceHash() => r'2a8ac0af1197d2406948c44b7f955dcc41acd383';
