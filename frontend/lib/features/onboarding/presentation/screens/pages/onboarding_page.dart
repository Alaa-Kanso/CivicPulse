import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/mobile_layout/mobile_onboarding_page.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/web_layout/web_onboarding_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (kIsWeb)
        ? const WebOnboardingPage()
        : BlocProvider(
            create: (BuildContext context) => sl<OnboardingCubit>(),
            child: MobileOnboardingPage(),
          );
  }
}
