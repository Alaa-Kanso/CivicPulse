import 'package:CivicPulse/features/auth/domain/repositories/auth_repository.dart';

class LogInUseCase {
  final AuthRepository repository;

  LogInUseCase({required this.repository});

  Future<void> call(String email, String password) async {
    await repository.logIn(email, password);
  }
}
