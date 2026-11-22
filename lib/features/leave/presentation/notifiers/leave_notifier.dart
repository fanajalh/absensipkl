import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/leave_request.dart';
import '../../repositories/leave_repository_impl.dart';

part 'leave_notifier.g.dart';

@riverpod
class LeaveNotifier extends _$LeaveNotifier {
  @override
  Future<List<LeaveRequest>> build() =>
      ref.watch(leaveRepositoryProvider).getRequests();

  Future<void> submitRequest(LeaveRequest request) async {
    final repo = ref.read(leaveRepositoryProvider);
    await repo.submitRequest(request);
    if (!ref.mounted) return;
    final updated = await repo.getRequests();
    if (!ref.mounted) return;
    state = AsyncData(updated);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(
      () => ref.read(leaveRepositoryProvider).getRequests(),
    );
    if (!ref.mounted) return;
    state = nextState;
  }
}
