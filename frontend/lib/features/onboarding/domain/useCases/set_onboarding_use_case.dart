import 'package:frontend/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingUseCase {
  final OnboardingRepository repository;

  SetOnboardingUseCase({required this.repository});

  Future<void> call()async{
    await repository.setOnboardingSeen();
  }
}