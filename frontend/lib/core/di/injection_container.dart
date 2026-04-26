import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/network/request_deduplicator.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:frontend/features/auth/data/dataSources/auth_remote_datasource.dart';
import 'package:frontend/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => RequestDeduplicator());
  sl.registerLazySingleton(() => SessionManager());
  sl.registerFactory(() => AuthCubit(sessionManager: sl()));
  sl.registerLazySingleton(() => ApiClient(dio: sl(), deduplicator: sl()));

  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(api: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), session: sl()),
  );

  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
}
