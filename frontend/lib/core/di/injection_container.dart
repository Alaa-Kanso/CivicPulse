import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/di/auth_injection.dart';
import 'package:frontend/features/onboarding/di/onboarding_injection.dart';
import 'package:frontend/features/reports/di/report_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await coreInit();
  await onboardingInit();
  await authInit();
  await reportInit();
}

Future<void> coreInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => SessionManager());
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
