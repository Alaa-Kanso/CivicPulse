import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/core/session/session_manager.dart';
import 'package:CivicPulse/device_info.dart';
import 'package:CivicPulse/features/auth/domain/entities/user.dart';
import 'package:CivicPulse/features/auth/domain/useCases/check_authenticated_use_case.dart';
import 'package:CivicPulse/features/auth/domain/useCases/logout_use_case.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:CivicPulse/features/onboarding/domain/useCases/seen_onboarding_use_case.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.onboardingUseCase,
    required this.checkAuthenticatedUseCase,
    required this.logoutUseCase,
    required this.sessionManager,
  }) : super(AuthInitial()) {
    _listenToSession();
  }

  final SeenOnboardingUseCase onboardingUseCase;
  final CheckAuthenticatedUseCase checkAuthenticatedUseCase;
  final LogoutUseCase logoutUseCase;
  final SessionManager sessionManager;
  late final StreamSubscription _authSub;

  void _listenToSession() {
    _authSub = sessionManager.authStream.listen((isLoggedIn) {
      if (isLoggedIn) {
        setAuthenticated(sessionManager.user!);
      } else {
        setUnAuthenticated();
      }
    });
  }


  Future<void> checkAuthenticated() async {
    emit(AuthLoading());
    final connectivity = await Connectivity().checkConnectivity();

    final isOffline =
        connectivity.isEmpty || connectivity.contains(ConnectivityResult.none);
    if (isOffline) {
      emit(AuthFailure(error: "No internet connection"));
      return;
    }
    try {
      final user = await checkAuthenticatedUseCase.call();
      if (user == null) {
        setUnAuthenticated();
        return;
      }
      setAuthenticated(user);
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
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

  Future<void> logout() async {
    await logoutUseCase.call();
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}
