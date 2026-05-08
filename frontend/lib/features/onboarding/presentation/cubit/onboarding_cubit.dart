import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/onboarding/domain/useCases/set_onboarding_use_case.dart';
import 'package:frontend/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.onboardingUseCase})
    : super(OnboardingPageManager(pageNb: 0));

  final SetOnboardingUseCase onboardingUseCase;

  void setPage(int page) {
    emit(OnboardingPageManager(pageNb: page));
  }

  Future<void> complete() async {
    await onboardingUseCase.call();
    emit(OnboardingSuccess());
  }
}
