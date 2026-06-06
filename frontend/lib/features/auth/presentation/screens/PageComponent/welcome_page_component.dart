import 'package:flutter/material.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';

class WelcomeMobileHeader extends StatelessWidget {
  const WelcomeMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Icon(
            Icons.location_city,
            color: Colors.white,
            size: 100,
          ),
        ),
        const SizedBox(height: 15),
        const BoldText(text: "CivicPulse", size: 40, color: Colors.white),
        const SizedBox(height: 10),
        const NormalText(
          text: "Report. Track. Improve Your City",
          size: 20,
          color: AppColors.accentSoft,
        ),
      ],
    );
  }
}

class WelcomeWebHeader extends StatelessWidget {
  const WelcomeWebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        image: DecorationImage(
          image: AssetImage("assets/images/welcome_header_background.png"),
          fit: .fill,
          colorFilter: ColorFilter.mode(
            Colors.blue.withOpacity(0.1),
            BlendMode.dstATop,
          ),
        ),
      ),
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                const BoldText(
                  text: "Smart Municipal",
                  size: 30.0,
                  color: Colors.white,
                ),
                const BoldText(
                  text: "Operations Platform",
                  size: 30.0,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 15),
                const NormalText(
                  text:
                      "Unified infrastructure oversight for the modern city. Streamline report workflows and resolution analytics in one secure hub.",
                  size: 20.0,
                  color: AppColors.accentSoft,
                  textAlign: .center,
                ),
                const SizedBox(height: 20.0),
                ActionButton(
                  text: "Portal Login",
                  textColor: AppColors.primary,
                  textSize: 20.0,
                  buttonColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/log-in");
                  },
                  borderColor: Colors.transparent,
                  buttonWidth: 200,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeWebBodyTop extends StatelessWidget {
  const WelcomeWebBodyTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(20.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NormalText(
              text: "PLATFORM CAPABILITIES",
              size: 20.0,
              color: AppColors.primary,
            ),
            const BoldText(
              text: "Reliable Infrastructure Management",
              size: 40.0,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            const NormalText(
              text:
                  "Designed for municipal operators to track, resolve, and audit public service requests efficiently.",
              size: 20.0,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureContainer extends StatelessWidget {
  const FeatureContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border, width: 2.0),
      ),
      padding: .all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 10.0),
          BoldText(text: title, size: 20.0, color: AppColors.textPrimary),
          const SizedBox(height: 5.0),
          NormalText(text: subTitle, size: 15, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class WelcomeWebBodyFeatures extends StatelessWidget {
  const WelcomeWebBodyFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmall = constraints.maxWidth < 700;
          return (isSmall)
              ? Column(
                  children: [
                    SizedBox(
                      width: .infinity,
                      child: FeatureContainer(
                        icon: Icons.map_outlined,
                        title: 'Regional Report Management',
                        subTitle:
                            'Localized tracking for specific jurisdictions with geo-fencing capabilities.',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: .infinity,
                      child: FeatureContainer(
                        icon: Icons.sync_alt_outlined,
                        title: 'Structured Status Workflow',
                        subTitle:
                            'End-to-end lifecycle management for every report from intake to resolution.',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: .infinity,
                      child: FeatureContainer(
                        icon: Icons.analytics_outlined,
                        title: 'Centralized Dashboard',
                        subTitle:
                            'Data-driven oversight for departmental performance and real-time trends.',
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: FeatureContainer(
                        icon: Icons.map_outlined,
                        title: 'Regional Report Management',
                        subTitle:
                            'Localized tracking for specific jurisdictions with geo-fencing capabilities.',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: FeatureContainer(
                        icon: Icons.sync_alt_outlined,
                        title: 'Structured Status Workflow',
                        subTitle:
                            'End-to-end lifecycle management for every report from intake to resolution.',
                      ),
                    ),

                    const SizedBox(width: 20),
                    Expanded(
                      child: FeatureContainer(
                        icon: Icons.analytics_outlined,
                        title: 'Centralized Dashboard',
                        subTitle:
                            'Data-driven oversight for departmental performance and real-time trends.',
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class WorksContainer extends StatelessWidget {
  const WorksContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: .all(8.0),
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                BoldText(text: title, size: 25.0, color: AppColors.textPrimary),
                const SizedBox(height: 10.0),
                NormalText(
                  text: subTitle,
                  size: 15.0,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WelcomeWebBodyWorks extends StatelessWidget {
  const WelcomeWebBodyWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      decoration: BoxDecoration(color: AppColors.surface),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BoldText(
              text: "How It Works",
              size: 30.0,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isSmall = constraints.maxWidth < 700;
                return (isSmall)
                    ? Column(
                        children: [
                          WorksContainer(
                            icon: Icons.description_outlined,
                            title: 'Capture Report',
                            subTitle:
                                'Citizen input via structured intake forms, including photo evidence and precise GPS coordinates.',
                          ),
                          const SizedBox(height: 15),
                          WorksContainer(
                            icon: Icons.settings_outlined,
                            title: 'Process & Assign',
                            subTitle:
                                'Automated routing to responsible departments based on category and region of the report.',
                          ),
                          const SizedBox(height: 15),
                          WorksContainer(
                            icon: Icons.verified_user,
                            title: 'Resolve & Audit',
                            subTitle:
                                'Final verification with immutable logging for departmental compliance and citizen feedback.',
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: WorksContainer(
                              icon: Icons.description_outlined,
                              title: 'Capture Report',
                              subTitle:
                                  'Citizen input via structured intake forms, including photo evidence and precise GPS coordinates.',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: WorksContainer(
                              icon: Icons.settings_outlined,
                              title: 'Process & Assign',
                              subTitle:
                                  'Automated routing to responsible departments based on category and region of the report.',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: WorksContainer(
                              icon: Icons.verified_user,
                              title: 'Resolve & Audit',
                              subTitle:
                                  'Final verification with immutable logging for departmental compliance and citizen feedback.',
                            ),
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeWebFooter extends StatelessWidget {
  const WelcomeWebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      decoration: BoxDecoration(color: AppColors.surface),
      child: Padding(
        padding: .all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.public_outlined,
                  color: AppColors.primary,
                  size: 40.0,
                ),
                const SizedBox(width: 10),
                BoldText(text: "CivicPulse", size: 30.0, color: Colors.black),
              ],
            ),
            const SizedBox(height: 10),
            const NormalText(
              text:
                  "Connecting citizens and city services through reliable, transparent, and efficient management software.",
              size: 20.0,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Center(
              child: NormalText(
                text:
                    "© 2026 CivicPulse Municipal Systems. All rights reserved.",
                size: 20.0,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
