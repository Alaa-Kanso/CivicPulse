import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';

class OnboardingFirstPage extends StatelessWidget {
  const OnboardingFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: .circular(10),
              ),
              width: .infinity,
              padding: .all(60.0),
              child: const Icon(
                Icons.camera_alt,
                size: 70.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20.0),
            const BoldText(
              text: "Report Issues Easily",
              size: 30.0,
              color: AppColors.textPrimary,
              textAlign: .center,
            ),
            const SizedBox(height: 10.0),
            const NormalText(
              text: "Submit municipal issues in just a few steps.",
              size: 20.0,
              color: AppColors.textSecondary,
              textAlign: .center,
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
