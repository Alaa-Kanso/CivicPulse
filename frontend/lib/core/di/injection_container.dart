import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:CivicPulse/core/session/session_manager.dart';
import 'package:CivicPulse/features/abuse_report/di/abuse_report_injection.dart';
import 'package:CivicPulse/features/auth/di/auth_injection.dart';
import 'package:CivicPulse/features/onboarding/di/onboarding_injection.dart';
import 'package:CivicPulse/features/operator/di/operator_injection.dart';
import 'package:CivicPulse/features/reports/di/report_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await coreInit();
  await onboardingInit();
  await authInit();
  await reportInit();
  await operatorInit();
  await abuseReportInit();
}

Future<void> coreInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => SessionManager());
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      webOptions: WebOptions(dbName: "civicpulse", publicKey: "civicpulsekey"),
    ),
  );
}
