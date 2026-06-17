import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:CivicPulse/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:CivicPulse/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/pages/onboarding_first_page.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/pages/onboarding_second_page.dart';
import 'package:CivicPulse/features/onboarding/presentation/screens/pages/onboarding_third_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MobileOnboardingPage extends StatefulWidget {
  const MobileOnboardingPage({super.key});

  @override
  State<MobileOnboardingPage> createState() => _MobileOnboardingPageState();
}

class _MobileOnboardingPageState extends State<MobileOnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit,OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        if(state is OnboardingSuccess){
          //user already registered so no need for check authenticated
          final user = context.read<AuthCubit>().sessionManager.user;
          if (user != null) {
            context.read<AuthCubit>().setAuthenticated(user);
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: .all(10.0),
          child: Column(
            children: [
              BlocBuilder<OnboardingCubit, OnboardingState>(
                buildWhen: (previous, current) =>
                    current is OnboardingPageManager,
                builder: (BuildContext context, OnboardingState state) {
                  final currentPage = (state as OnboardingPageManager).pageNb;

                  return Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      (currentPage <= 0)
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },

                              icon: Icon(Icons.arrow_back_outlined),
                            ),
                      (currentPage >= 2)
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                context.read<OnboardingCubit>().complete();
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(fontSize: 25.0),
                              ),
                            ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      context.read<OnboardingCubit>().setPage(value);
                    },
                    children: [
                      OnboardingFirstPage(),
                      OnboardingSecondPage(),
                      OnboardingThirdPage(),
                    ],
                  ),
                ),
              ),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (BuildContext context, OnboardingState state) {
                  final currentPage = (state as OnboardingPageManager).pageNb;
                  return (currentPage < 2)
                      ? ActionButton(
                          text: "Next",
                          textColor: AppColors.textLight,
                          textSize: 20.0,
                          buttonColor: AppColors.primary,
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          borderColor: Colors.transparent,
                        )
                      : ActionButton(
                          text: "Get Started",
                          textColor: AppColors.textLight,
                          textSize: 20.0,
                          buttonColor: AppColors.primary,
                          onPressed: () {
                            context.read<OnboardingCubit>().complete();
                          },
                          borderColor: Colors.transparent,
                        );
                },
              ),
              SizedBox(height: 20.0),
              SmoothPageIndicator(controller: _pageController, count: 3),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
