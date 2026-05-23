import 'package:frontend/features/operator/data/dataSources/operator_remote_data_source.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class OperatorRepositoryImpl extends OperatorRepository {
  final OperatorRemoteDataSource operatorRemoteDataSource;

  OperatorRepositoryImpl({required this.operatorRemoteDataSource});

  @override
  Future<void> createOperator({
    required String email,
    required String password,
    required int municipalityId,
  }) async {
    await operatorRemoteDataSource.createOperator(
      email: email,
      password: password,
      municipalityId: municipalityId,
    );
  }

  @override
  Future<void> getMunicipalities() async {
    await operatorRemoteDataSource.getMunicipalities();
  }
}
