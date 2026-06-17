import 'package:CivicPulse/features/operator/domain/repositories/operator_repository.dart';

class CreateOperatorUseCase {
  final OperatorRepository operatorRepository;

  CreateOperatorUseCase({required this.operatorRepository});

  Future<void> call({
    required String email,
    required String password,
    required int municipalityId,
  }) async {
    await operatorRepository.createOperator(
      email: email,
      password: password,
      municipalityId: municipalityId,
    );
  }
}
