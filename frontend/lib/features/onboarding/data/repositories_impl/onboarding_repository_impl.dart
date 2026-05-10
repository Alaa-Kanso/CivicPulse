import 'package:frontend/features/onboarding/data/dataSources/onboarding_local_datasource.dart';
import 'package:frontend/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl extends OnboardingRepository {
  final OnboardingLocalDatasource local;

  OnboardingRepositoryImpl({required this.local});

  @override
  bool isOnboardingSeen() {
    return local.isOnboardingSeen();
  }

  @override
  Future<void> setOnboardingSeen() async{
    await local.setOnboardingSeen();
  }
}
