import 'package:CivicPulse/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password);

  Future<void> logIn(String email, String password);

  Future<User?> restoreSession();
  Future<void> logout();
}
