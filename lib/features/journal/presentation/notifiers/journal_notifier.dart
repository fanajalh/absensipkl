import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/journal_entry.dart';
import '../../repositories/journal_repository_impl.dart';

part 'journal_notifier.g.dart';

@riverpod
class JournalNotifier extends _$JournalNotifier {
  @override
  Future<List<JournalEntry>> build() =>
      ref.watch(journalRepositoryProvider).getEntries();

  Future<void> saveEntry(JournalEntry entry) async {
    final repo = ref.read(journalRepositoryProvider);
    await repo.saveEntry(entry);
    if (!ref.mounted) return;
    final updated = await repo.getEntries();
    if (!ref.mounted) return;
    state = AsyncData(updated);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(
      () => ref.read(journalRepositoryProvider).getEntries(),
    );
    if (!ref.mounted) return;
    state = nextState;
  }
}
