import 'package:CivicPulse/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<void> call(String email, String password) async {
    await repository.signUp(email, password);
  }
}
