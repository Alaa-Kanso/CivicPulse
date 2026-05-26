import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/domain/repositories/municipality_repository.dart';

class GetAllMunicipalitiesUseCase {
  final MunicipalityRepository municipalityRepository;

  GetAllMunicipalitiesUseCase({required this.municipalityRepository});

  Future<List<Municipality>> call() async {
    return await municipalityRepository.getAllMunicipalities();
  }
}
