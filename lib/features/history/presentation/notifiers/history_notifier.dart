import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/attendance_recap.dart';
import '../../domain/entities/history_filter.dart';
import '../../repositories/history_repository_impl.dart';

part 'history_notifier.freezed.dart';
part 'history_notifier.g.dart';

@freezed
abstract class HistoryViewState with _$HistoryViewState {
  const factory HistoryViewState({
    required int year,
    required int month,
    required HistoryFilter filter,
    required AttendanceRecap recap,
  }) = _HistoryViewState;
}

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  Future<HistoryViewState> build() async {
    final now = DateTime.now();
    final recap = await ref.watch(historyRepositoryProvider).getMonthlyRecap(
          year: now.year,
          month: now.month,
          filter: HistoryFilter.all,
        );
    return HistoryViewState(
      year: now.year,
      month: now.month,
      filter: HistoryFilter.all,
      recap: recap,
    );
  }

  Future<void> setFilter(HistoryFilter filter) async {
    final current = state.asData?.value;
    if (current == null || current.filter == filter) return;

    final nextState = await AsyncValue.guard(() async {
      final recap = await ref.read(historyRepositoryProvider).getMonthlyRecap(
            year: current.year,
            month: current.month,
            filter: filter,
          );
      return current.copyWith(
        filter: filter,
        recap: recap,
      );
    });
    if (!ref.mounted) return;
    state = nextState;
  }

  Future<void> refresh() async {
    final current = state.asData?.value;
    final now = DateTime.now();
    final year = current?.year ?? now.year;
    final month = current?.month ?? now.month;
    final filter = current?.filter ?? HistoryFilter.all;

    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(() async {
      final recap = await ref.read(historyRepositoryProvider).getMonthlyRecap(
            year: year,
            month: month,
            filter: filter,
          );
      return HistoryViewState(
        year: year,
        month: month,
        filter: filter,
        recap: recap,
      );
    });
    if (!ref.mounted) return;
    state = nextState;
  }
}
