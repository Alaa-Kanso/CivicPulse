import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/domain/repositories/municipality_repository.dart';

class GetAssignedMunicipalitiesUseCase {
  final MunicipalityRepository municipalityRepository;

  GetAssignedMunicipalitiesUseCase({required this.municipalityRepository});

  Future<List<Municipality>> call()async{
    return await municipalityRepository.getAssignedMunicipalities();
  }
}
