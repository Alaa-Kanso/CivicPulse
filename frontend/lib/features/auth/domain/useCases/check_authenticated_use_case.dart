import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthenticatedUseCase {
  final AuthRepository repository;

  CheckAuthenticatedUseCase({required this.repository});

  Future<User?> call() async {
    return await repository.restoreSession();
  }
}
