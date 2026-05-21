import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/device_info.dart';
import 'package:frontend/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:frontend/features/auth/data/dataSources/auth_remote_datasource.dart';
import 'package:frontend/features/auth/data/utils/token_decoder.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDataSource local;
  final SessionManager session;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.session,
  });

  @override
  Future<void> signUp(String email, String password) async {
    final response = await remote.signUp(email: email, password: password);
    final user = TokenDecoder.decode(response.accessToken);
    session.saveSession(accessToken: response.accessToken, user: user);
    await local.saveRefreshToken(response.refreshToken);
  }

  @override
  Future<void> logIn(String email, String password) async {
    final response = await remote.logIn(email: email, password: password);
    final user = TokenDecoder.decode(response.accessToken);
    session.saveSession(accessToken: response.accessToken, user: user);
    await local.saveRefreshToken(response.refreshToken);
  }

  @override
  Future<User?> restoreSession() async {
    final refreshToken = await local.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }
    final response = await remote.refresh(
      refreshToken: refreshToken,
      deviceType: DeviceInfo.getDevicePlatform(),
    );

    final accessToken = response.accessToken;

    final newRefreshToken = response.refreshToken;

    final user = TokenDecoder.decode(accessToken);

    session.saveSession(accessToken: accessToken, user: user);

    await local.saveRefreshToken(newRefreshToken);

    return user;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await local.getRefreshToken();
    await remote.logout(refreshToken: refreshToken ?? "");
    await local.clearRefreshToken();
    session.clearSession();
  }
}
