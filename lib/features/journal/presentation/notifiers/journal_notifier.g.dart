// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JournalNotifier)
final journalProvider = JournalNotifierProvider._();

final class JournalNotifierProvider
    extends $AsyncNotifierProvider<JournalNotifier, List<JournalEntry>> {
  JournalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalNotifierHash();

  @$internal
  @override
  JournalNotifier create() => JournalNotifier();
}

String _$journalNotifierHash() => r'9051142c7318a6071fca294b5340e02a0f6a15d0';

abstract class _$JournalNotifier extends $AsyncNotifier<List<JournalEntry>> {
  FutureOr<List<JournalEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<JournalEntry>>, List<JournalEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<JournalEntry>>, List<JournalEntry>>,
              AsyncValue<List<JournalEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
