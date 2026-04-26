import 'package:frontend/features/auth/domain/entities/user.dart';

class SessionManager {
  String? _accessToken;
  User? _user;

  void saveSession({required String accessToken, required User user}) {
    _accessToken = accessToken;
    _user = user;
  }

  // 📥 Getters
  String? get accessToken => _accessToken;

  User? get user => _user;

  bool get isAuthenticated => _accessToken != null;

  // 🚪 Clear session
  void clearSession() {
    _accessToken = null;
    _user = null;
  }
}
