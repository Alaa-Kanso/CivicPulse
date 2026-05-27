import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/operator/data/dataSources/municipality_remote_data_source.dart';
import 'package:frontend/features/operator/data/dataSources/operator_remote_data_source.dart';
import 'package:frontend/features/operator/data/repository_impl/municipality_repository_impl.dart';
import 'package:frontend/features/operator/data/repository_impl/operator_repository_impl.dart';
import 'package:frontend/features/operator/domain/repositories/municipality_repository.dart';
import 'package:frontend/features/operator/domain/repositories/operator_repository.dart';
import 'package:frontend/features/operator/domain/useCases/create_operator_use_case.dart';
import 'package:frontend/features/operator/domain/useCases/get_all_municipalities_use_case.dart';
import 'package:frontend/features/operator/domain/useCases/get_assigned_municipalities_use_case.dart';
import 'package:frontend/features/operator/presentation/cubit/all_municipalities_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/assigned_municipalities_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_cubit.dart';

Future<void> operatorInit() async {
  //Data source

  sl.registerLazySingleton<OperatorRemoteDataSource>(
    () => OperatorRemoteDataSource(apiClient: sl()),
  );
  sl.registerLazySingleton<MunicipalityRemoteDataSource>(
    () => MunicipalityRemoteDataSource(apiClient: sl()),
  );

  //Repository
  sl.registerLazySingleton<OperatorRepository>(
    () => OperatorRepositoryImpl(operatorRemoteDataSource: sl()),
  ); //Repository
  sl.registerLazySingleton<MunicipalityRepository>(
    () => MunicipalityRepositoryImpl(municipalityRemoteDataSource: sl()),
  );

  //useCase
  sl.registerLazySingleton(
    () => CreateOperatorUseCase(operatorRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAllMunicipalitiesUseCase(municipalityRepository: sl()),
  );
 sl.registerLazySingleton(
    () => GetAssignedMunicipalitiesUseCase(municipalityRepository: sl()),
  );

  //cubit
  sl.registerFactory(() => CreateOperatorCubit(createOperatorUseCase: sl()));
  sl.registerFactory(
    () => AllMunicipalitiesCubit(getMunicipalitiesUseCase: sl()),
  ); sl.registerFactory(
    () => AssignedMunicipalitiesCubit(getAssignedMunicipalitiesUseCase: sl()),
  );
}
