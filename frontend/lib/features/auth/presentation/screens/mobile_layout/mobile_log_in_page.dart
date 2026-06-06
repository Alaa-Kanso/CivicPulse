import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/screens/PageComponent/log_in_page_component.dart';

class MobileLogInPage extends StatefulWidget {
  const MobileLogInPage({super.key});

  @override
  State<MobileLogInPage> createState() => _MobileLogInPageState();
}

class _MobileLogInPageState extends State<MobileLogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const LogInMobileHeader(),
                  const SizedBox(height: 30.0),
                  LogInFormSection(
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  const LogInForgetPasswordButton(),
                  const SizedBox(height: 10.0),
                  const LogInErrorSection(),
                  const SizedBox(height: 5.0),
                  LogInButton(
                    onPressed: () {
                      context.read<LogInCubit>().logIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    alignment: .center,
                    crossAxisAlignment: .center,
                    children: [
                      NormalText(
                        text: "Don't have an account? ",
                        size: 15.0,
                        color: AppColors.textSecondary,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/sign-up");
                        },
                        child: Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        LogInCircularSection(),
      ],
    );
  }
}
