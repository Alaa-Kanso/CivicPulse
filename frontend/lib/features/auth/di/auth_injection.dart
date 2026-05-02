import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:frontend/features/auth/data/dataSources/auth_remote_datasource.dart';
import 'package:frontend/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/useCases/log_in_use_case.dart';
import 'package:frontend/features/auth/domain/useCases/sign_up_use_case.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/sign_up_cubit.dart';

Future<void> authInit() async {
  //Data source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(api: sl()),
  );

  //Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), session: sl()),
  );

  //useCase
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogInUseCase(repository: sl()));

  //cubit
  sl.registerFactory(() => AuthCubit(sessionManager: sl()));
  sl.registerFactory(() => SignUpCubit(signUpUseCase: sl()));
  sl.registerFactory(() => LogInCubit(logInUseCase: sl()));
}
