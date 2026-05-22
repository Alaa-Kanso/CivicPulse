import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class CreateOperatorUseCase {
  final OperatorRepository operatorRepository;

  CreateOperatorUseCase({required this.operatorRepository});
  Future<void> call()async{
    await operatorRepository.createOperator();
  }
}
