import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/network/request_deduplicator.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/di/auth_injection.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;


Future<void> initDependencies() async {
  await coreInit();
  await authInit();
}

Future<void> coreInit()async{
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => RequestDeduplicator());
  sl.registerLazySingleton(() => SessionManager());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  sl.registerLazySingleton(() => ApiClient(dio: sl(), deduplicator: sl()));
}