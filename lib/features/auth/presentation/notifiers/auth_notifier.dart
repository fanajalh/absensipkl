import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_error.dart';
import '../../domain/entities/dudi_placement.dart';
import '../../repositories/auth_repository_impl.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    Future<void>.microtask(restoreSession);
    return const AuthState.loading();
  }

  Future<void> restoreSession() async {
    try {
      final session = await ref.read(authRepositoryProvider).restoreSession();
      if (!ref.mounted) return;
      state = session == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(session);
    } catch (error) {
      if (!ref.mounted) return;
      state = AuthState.unauthenticated(
        error: AppErrorMapper.fromObject(error),
      );
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = const AuthState.authenticating();
    try {
      final session = await ref.read(authRepositoryProvider).login(
            identifier: identifier,
            password: password,
          );
      if (!ref.mounted) return;
      state = AuthState.authenticated(session);
    } catch (error) {
      if (!ref.mounted) return;
      state = AuthState.unauthenticated(
        error: AppErrorMapper.fromObject(error),
      );
    }
  }

  void syncPlacement(DudiPlacement placement) {
    final current = state;
    if (current is AuthAuthenticated &&
        current.session.student.placement != placement) {
      state = AuthState.authenticated(
        current.session.copyWith(
          student: current.session.student.copyWith(placement: placement),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
      if (!ref.mounted) return;
      state = const AuthState.unauthenticated();
    } catch (error) {
      if (!ref.mounted) return;
      state = AuthState.unauthenticated(
        error: AppErrorMapper.fromObject(error),
      );
    }
  }
}
