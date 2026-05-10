import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/device_info.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/onboarding/domain/useCases/seen_onboarding_use_case.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.sessionManager, required this.onboardingUseCase})
    : super(AuthInitial());

  final SessionManager sessionManager;

  final SeenOnboardingUseCase onboardingUseCase;

  void checkAuthenticated() {
    if (sessionManager.isAuthenticated) {
      if (sessionManager.user == null) {
        setUnAuthenticated();
        return;
      }
      setAuthenticated(sessionManager.user!);
      return;
    }
    setUnAuthenticated();
  }

  void setAuthenticated(User user) {
    if (DeviceInfo.getDevicePlatform() == "App" && !onboardingUseCase.call()) {
      emit(AuthAuthenticatedGoBoarding());
      return;
    }
    emit(AuthAuthenticatedGoHome(user: user));
  }

  void setUnAuthenticated() {
    emit(AuthUnAuthenticated());
  }
}
