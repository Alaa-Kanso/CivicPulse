import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/core/network/request_deduplicator.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/di/auth_injection.dart';
import 'package:frontend/features/onboarding/di/onboarding_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await coreInit();
  await onboardingInit();
  await authInit();
}

Future<void> coreInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => RequestDeduplicator());
  sl.registerLazySingleton(() => SessionManager());
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => ApiClient(dio: sl(), deduplicator: sl()));
}
