import 'package:dio/dio.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/core/network/api_client.dart';
import 'package:CivicPulse/core/network/interceptors/auth_interceptor.dart';
import 'package:CivicPulse/core/network/interceptors/error_interceptor.dart';
import 'package:CivicPulse/core/network/interceptors/refresh_interceptor.dart';
import 'package:CivicPulse/core/network/interceptors/trace_interceptor.dart';
import 'package:CivicPulse/core/network/request_deduplicator.dart';
import 'package:CivicPulse/device_info.dart';
import 'package:CivicPulse/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:CivicPulse/features/auth/data/dataSources/auth_remote_datasource.dart';
import 'package:CivicPulse/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:CivicPulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:CivicPulse/features/auth/domain/useCases/check_authenticated_use_case.dart';
import 'package:CivicPulse/features/auth/domain/useCases/log_in_use_case.dart';
import 'package:CivicPulse/features/auth/domain/useCases/logout_use_case.dart';
import 'package:CivicPulse/features/auth/domain/useCases/sign_up_use_case.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/sign_up_cubit.dart';

Future<void> authInit() async {
  sl.registerLazySingleton(() => RequestDeduplicator());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(storage: sl()),
  );

  final baseOptions = BaseOptions(
    baseUrl: (DeviceInfo.getDevicePlatform() == "Web")
        ? "http://localhost:5139/api"
        : "http://192.168.0.198:5139/api",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  );

  sl.registerLazySingleton<Dio>(() => Dio(baseOptions));

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sessionManager: sl()),
  );

  sl.registerLazySingleton<RefreshInterceptor>(
    () => RefreshInterceptor(authLocalDataSource: sl(), sessionManager: sl()),
  );

  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());
  sl.registerLazySingleton<TraceInterceptor>(() => TraceInterceptor());
  sl<Dio>().interceptors.addAll([
    sl<TraceInterceptor>(),
    sl<AuthInterceptor>(),
    sl<RefreshInterceptor>(),
    sl<ErrorInterceptor>(),
  ]);

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl<Dio>(), deduplicator: sl<RequestDeduplicator>()),
  );

  // =========================
  // DATA SOURCES
  // =========================

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(api: sl()),
  );

  // =========================
  // REPOSITORY
  // =========================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), session: sl()),
  );

  // =========================
  // USE CASES
  // =========================

  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogInUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthenticatedUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));

  // =========================
  // CUBITS
  // =========================

  sl.registerFactory(
    () => AuthCubit(
      onboardingUseCase: sl(),
      checkAuthenticatedUseCase: sl(),
      logoutUseCase: sl(),
      sessionManager: sl(),
    ),
  );

  sl.registerFactory(() => SignUpCubit(signUpUseCase: sl()));
  sl.registerFactory(() => LogInCubit(logInUseCase: sl()));
}
