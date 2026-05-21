import 'dart:async';

import 'package:frontend/features/auth/domain/entities/user.dart';

class SessionManager {
  String? _accessToken;
  User? _user;

  final StreamController<bool> _authController =
      StreamController<bool>.broadcast();

  Stream<bool> get authStream => _authController.stream;

  // 📥 Getters
  String? get accessToken => _accessToken;

  User? get user => _user;

  bool get isAuthenticated => _accessToken != null;

  void saveSessionWithListener({
    required String accessToken,
    required User user,
  }) {
    _accessToken = accessToken;
    _user = user;

    // 🔥 notify listeners
    _authController.add(true);
  }

  void saveSession({required String accessToken, required User user}) {
    _accessToken = accessToken;
    _user = user;
  }

  // 🚪 Clear session
  void clearSession() {
    _accessToken = null;
    _user = null;

    // 🔥 notify listeners
    _authController.add(false);
  }

  void dispose() {
    _authController.close();
  }
}
