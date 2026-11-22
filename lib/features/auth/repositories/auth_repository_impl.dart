import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/secure_storage_datasource.dart';
import '../data/datasources/auth_datasource.dart';
import '../data/datasources/demo_auth_datasource.dart';
import '../data/datasources/local_auth_datasource.dart';
import '../data/datasources/remote_auth_datasource.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDatasource remoteDatasource,
    required LocalAuthDatasource localDatasource,
  })  : _remote = remoteDatasource,
        _local = localDatasource;

  final AuthDatasource _remote;
  final LocalAuthDatasource _local;

  @override
  Future<AuthSession?> restoreSession() async {
    final dto = await _local.readSession();
    if (dto == null) return null;

    final session = dto.toEntity();
    if (session.isExpiredAt(DateTime.now())) {
      await _local.clearSession();
      return null;
    }
    return session;
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    final dto = await _remote.login(
      identifier: identifier,
      password: password,
    );
    await _local.saveSession(dto);
    return dto.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    await _local.clearSession();
  }
}

@Riverpod(keepAlive: true)
AuthDatasource authDatasource(Ref ref) => AppConfig.useDemoMode
    ? DemoAuthDatasource()
    : RemoteAuthDatasource(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
LocalAuthDatasource localAuthDatasource(Ref ref) =>
    SecureLocalAuthDatasource(ref.watch(secureStorageDatasourceProvider));

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      remoteDatasource: ref.watch(authDatasourceProvider),
      localDatasource: ref.watch(localAuthDatasourceProvider),
    );
