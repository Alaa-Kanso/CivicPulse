import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:CivicPulse/features/auth/presentation/screens/PageComponent/auth_failure_page.dart';
import 'package:CivicPulse/features/auth/presentation/screens/PageComponent/auth_loading_page.dart';
import 'package:CivicPulse/features/auth/presentation/screens/nav/auth_nav.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/pages/onboarding_page.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Pages/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticatedGoBoarding) {
          return const OnboardingPage();
        }
        if (state is AuthAuthenticatedGoHome) {
          return HomePage(user: state.user);
        }
        if (state is AuthFailure) {
          return AuthFailurePage(error: state.error);
        }

        if (state is AuthLoading) {
          return const AuthLoadingPage();
        }

        return AuthNav();
      },
    );
  }
}
