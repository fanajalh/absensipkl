// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_clock_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits the current local [DateTime] every second for tabular clock UI.

@ProviderFor(LiveClockNotifier)
final liveClockProvider = LiveClockNotifierProvider._();

/// Emits the current local [DateTime] every second for tabular clock UI.
final class LiveClockNotifierProvider
    extends $NotifierProvider<LiveClockNotifier, DateTime> {
  /// Emits the current local [DateTime] every second for tabular clock UI.
  LiveClockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveClockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveClockNotifierHash();

  @$internal
  @override
  LiveClockNotifier create() => LiveClockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$liveClockNotifierHash() => r'b05333b6e2aefd0d50f9db683df5306331645947';

/// Emits the current local [DateTime] every second for tabular clock UI.

abstract class _$LiveClockNotifier extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
