import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSource({required this.storage});

  static const _refreshTokenKey = "refreshToken";

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await storage.delete(key: _refreshTokenKey);
  }
}
