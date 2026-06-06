import 'package:flutter/material.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';

class WebOnboardingPage extends StatelessWidget {
  const WebOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BoldText(
          text: "There is no onboarding page for website",
          size: 30.0,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
