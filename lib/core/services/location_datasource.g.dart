// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationDatasource)
final locationDatasourceProvider = LocationDatasourceProvider._();

final class LocationDatasourceProvider
    extends
        $FunctionalProvider<
          LocationDatasource,
          LocationDatasource,
          LocationDatasource
        >
    with $Provider<LocationDatasource> {
  LocationDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationDatasourceHash();

  @$internal
  @override
  $ProviderElement<LocationDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationDatasource create(Ref ref) {
    return locationDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationDatasource>(value),
    );
  }
}

String _$locationDatasourceHash() =>
    r'c495843bec6ebe333dc85ad7f430cc3c6b4b317d';
