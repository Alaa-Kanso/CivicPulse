import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';

class OnboardingSecondPage extends StatelessWidget {
  const OnboardingSecondPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: .circular(10),
                    ),
                    width: .infinity,
                    padding: .all(50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: .circular(180),
                      ),
                      padding: EdgeInsetsGeometry.all(30.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.diversity_3,
                            size: 100.0,
                            color: AppColors.primary,
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: .spaceEvenly,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 20.0,
                                  color: AppColors.primary,
                                ),
                                Icon(
                                  Icons.volunteer_activism,
                                  size: 20.0,
                                  color: AppColors.primary,
                                ),
                                Icon(
                                  Icons.handshake,
                                  size: 20.0,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const BoldText(
                    text: "Track Progress\nin Real-Time",
                    size: 30.0,
                    color: AppColors.textPrimary,
                    textAlign: .center,
                  ),
                  const SizedBox(height: 10.0),
                  const NormalText(
                    text:
                        " Stay updated on city fixes. Receive instant emails as your reported issues move from inspection to resolution.",
                    size: 20.0,
                    color: AppColors.textSecondary,
                    textAlign: .center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
