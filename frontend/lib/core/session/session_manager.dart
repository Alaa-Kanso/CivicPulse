import 'dart:async';

import 'package:frontend/features/auth/domain/entities/user.dart';

class SessionManager {
  String? _accessToken;
  String? _refreshToken;
  User? _user;

  final StreamController<bool> _authController =
      StreamController<bool>.broadcast();

  Stream<bool> get authStream => _authController.stream;

  // 📥 Getters
  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  User? get user => _user;

  bool get isAuthenticated => _accessToken != null;

  void saveSessionWithListener({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _user = user;

    // 🔥 notify listeners
    _authController.add(true);
  }

  void saveSession({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _user = user;
  }

  // 🚪 Clear session
  void clearSession() {
    _accessToken = null;
    _refreshToken = null;
    _user = null;

    // 🔥 notify listeners
    _authController.add(false);
  }

  void dispose() {
    _authController.close();
  }
}
