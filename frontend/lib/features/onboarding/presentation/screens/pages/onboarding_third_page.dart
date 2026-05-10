import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';

class OnboardingThirdPage extends StatelessWidget {
  const OnboardingThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: .circular(10.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/onboarding_image.png"),
                  fit: .cover,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            BoldText(
              text: "See Your City Improve",
              size: 30.0,
              color: AppColors.textPrimary,
              textAlign: .center,
            ),
            SizedBox(height: 10.0),
            NormalText(
              text:
                  " Track the real-world impact of your reports. Join thousands of neighbors in building a safer, smoother, and better community for everyone.",
              size: 20.0,
              color: AppColors.textSecondary,
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
