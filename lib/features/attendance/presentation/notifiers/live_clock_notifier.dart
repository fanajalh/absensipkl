import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_clock_notifier.g.dart';

/// Emits the current local [DateTime] every second for tabular clock UI.
@riverpod
class LiveClockNotifier extends _$LiveClockNotifier {
  @override
  DateTime build() {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (ref.mounted) {
        state = DateTime.now();
      }
    });
    ref.onDispose(timer.cancel);
    return DateTime.now();
  }
}
