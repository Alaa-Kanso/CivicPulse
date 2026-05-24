import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class GetMunicipalitiesUseCase {
  final OperatorRepository operatorRepository;

  GetMunicipalitiesUseCase({required this.operatorRepository});

  Future<List<Municipality>> call() async {
    return await operatorRepository.getMunicipalities();
  }
}
