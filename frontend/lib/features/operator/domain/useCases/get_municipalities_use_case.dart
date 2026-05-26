import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class GetAssignedMunicipalitiesUseCase {
  final OperatorRepository operatorRepository;

  GetAssignedMunicipalitiesUseCase({required this.operatorRepository});

  Future<List<Municipality>> call() async {
    return await operatorRepository.getAssignedMunicipalities();
  }
}
