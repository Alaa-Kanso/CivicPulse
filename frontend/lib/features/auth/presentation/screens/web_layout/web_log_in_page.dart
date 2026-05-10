import 'package:flutter/material.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/auth/presentation/screens/PageComponent/log_in_page_component.dart';

class WebLogInPage extends StatefulWidget {
  const WebLogInPage({super.key});

  @override
  State<WebLogInPage> createState() => _WebLogInPageState();
}

class _WebLogInPageState extends State<WebLogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static const mobileBreakpoint = 750.0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < mobileBreakpoint
                  ? _buildMobileLayout()
                  : _buildDesktopLayout();
            },
          ),
          const LogInCircularSection(),
        ],
      );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            const LogInWebHeader(),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogInSection(
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 10),
                  const LogInFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    image: DecorationImage(
                      image: const AssetImage(
                        "assets/images/welcome_background.png",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(0.1),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                  child: const LogInWebHeader(),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: LogInSection(
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const LogInFooter(),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
