import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/operator/data/dataSources/operator_remote_data_source.dart';
import 'package:frontend/features/operator/data/repository_impl/operator_repository_impl.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';
import 'package:frontend/features/operator/domain/useCases/create_operator_use_case.dart';
import 'package:frontend/features/operator/domain/useCases/get_municipalities_use_case.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/get_assigned_municipalities_cubit.dart';

Future<void> operatorInit() async {
  //Data source

  sl.registerLazySingleton<OperatorRemoteDataSource>(
    () => OperatorRemoteDataSource(apiClient: sl()),
  );

  //Repository
  sl.registerLazySingleton<OperatorRepository>(
    () => OperatorRepositoryImpl(operatorRemoteDataSource: sl()),
  );

  //useCase
  sl.registerLazySingleton(
    () => CreateOperatorUseCase(operatorRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAssignedMunicipalitiesUseCase(operatorRepository: sl()),
  );

  //cubit
  sl.registerFactory(() => CreateOperatorCubit(createOperatorUseCase: sl()));
  sl.registerFactory(
    () =>
        GetAssignedMunicipalitiesCubit(getAssignedMunicipalitiesUseCase: sl()),
  );
}
