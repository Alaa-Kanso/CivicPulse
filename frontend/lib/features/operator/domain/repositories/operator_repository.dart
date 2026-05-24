import 'package:frontend/features/operator/domain/entities/municipality.dart';

abstract class OperatorRepository {
  Future<void> createOperator({
    required String email,
    required String password,
    required int municipalityId,
  });

  Future<List<Municipality>> getMunicipalities();
}
