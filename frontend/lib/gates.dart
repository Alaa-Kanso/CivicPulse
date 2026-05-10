import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_state.dart';
import 'package:frontend/features/auth/presentation/screens/nav/auth_nav.dart';
import 'package:frontend/features/onboarding/presentation/screens/pages/onboarding_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        if(state is AuthAuthenticatedGoBoarding){
          return const OnboardingPage();
        }
        if(state is AuthAuthenticatedGoHome){

        }
        if(state is AuthLoading){

        }
        return AuthNav();
      },
    );
  }
}
