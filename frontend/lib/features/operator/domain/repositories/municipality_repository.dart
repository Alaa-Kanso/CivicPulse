import 'package:frontend/features/operator/domain/entities/municipality.dart';

abstract class MunicipalityRepository {
  Future<List<Municipality>> getAllMunicipalities();

  Future<List<Municipality>> getAssignedMunicipalities();
}
