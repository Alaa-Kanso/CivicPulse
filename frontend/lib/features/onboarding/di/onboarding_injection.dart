import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/onboarding/data/dataSources/onboarding_local_datasource.dart';
import 'package:CivicPulse/features/onboarding/data/repositories_impl/onboarding_repository_impl.dart';
import 'package:CivicPulse/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:CivicPulse/features/onboarding/domain/useCases/seen_onboarding_use_case.dart';
import 'package:CivicPulse/features/onboarding/domain/useCases/set_onboarding_use_case.dart';
import 'package:CivicPulse/features/onboarding/presentation/cubit/onboarding_cubit.dart';

Future<void> onboardingInit() async {
  sl.registerLazySingleton<OnboardingLocalDatasource>(
    () => OnboardingLocalDatasource(prefs: sl()),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(local: sl()),
  );

  sl.registerLazySingleton(() => SeenOnboardingUseCase(repository: sl()));
  sl.registerLazySingleton(() => SetOnboardingUseCase(repository: sl()));

  sl.registerFactory(() => OnboardingCubit(onboardingUseCase: sl()));
}
