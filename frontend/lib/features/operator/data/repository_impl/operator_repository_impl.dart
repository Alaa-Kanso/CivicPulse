import 'package:frontend/features/operator/data/dataSources/operator_remote_data_source.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';

class OperatorRepositoryImpl extends OperatorRepository {
  final OperatorRemoteDataSource operatorRemoteDataSource;

  OperatorRepositoryImpl({required this.operatorRemoteDataSource});
  @override
  Future<void> createOperator() async {}
}
