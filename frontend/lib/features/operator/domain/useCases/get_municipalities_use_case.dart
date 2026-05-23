import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class GetMunicipalitiesUseCase {
  final OperatorRepository operatorRepository;

  GetMunicipalitiesUseCase({required this.operatorRepository});

  Future<void> call()async{
    operatorRepository.getMunicipalities();
  }
}