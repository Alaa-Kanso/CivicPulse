
import 'package:CivicPulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:CivicPulse/features/onboarding/domain/repositories/onboarding_repository.dart';

class SeenOnboardingUseCase {

  final OnboardingRepository repository;

  SeenOnboardingUseCase({required this.repository});

  bool call(){
    return repository.isOnboardingSeen();
  }
}