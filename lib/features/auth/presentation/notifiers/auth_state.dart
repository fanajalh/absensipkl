import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_error.dart';
import '../../domain/entities/auth_session.dart';

part 'auth_state.freezed.dart';

/// Exhaustive sealed authentication state for router guards & login UI.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.loading() = AuthLoading;

  const factory AuthState.unauthenticated({AppError? error}) =
      AuthUnauthenticated;

  const factory AuthState.authenticating() = AuthAuthenticating;

  const factory AuthState.authenticated(AuthSession session) =
      AuthAuthenticated;
}
