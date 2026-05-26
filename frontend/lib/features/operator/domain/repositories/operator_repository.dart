abstract class OperatorRepository {
  Future<void> createOperator({
    required String email,
    required String password,
    required int municipalityId,
  });
}
