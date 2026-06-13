import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/log_in_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/log_in_state.dart';

class LogInMobileHeader extends StatelessWidget {
  const LogInMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BoldText(
          text: "Welcome Back",
          size: 30.0,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: 5.0),
        NormalText(
          text: "Empowering your community",
          size: 20.0,
          color: AppColors.textSecondary,
          textAlign: .center,
        ),
      ],
    );
  }
}

class LogInWebHeader extends StatelessWidget {
  const LogInWebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: AlignmentGeometry.topLeft,child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        )),
        Expanded(
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              const BoldText(text: "Welcome Back", size: 30.0, color: Colors.white),
              const SizedBox(height: 5.0),
              const NormalText(
                text: "Empowering Communities",
                size: 20.0,
                color: AppColors.primaryLight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LogInFormSection extends StatefulWidget {
  const LogInFormSection({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LogInFormSection> createState() => _LogInFormSectionState();
}

class _LogInFormSectionState extends State<LogInFormSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      builder: (BuildContext context, LogInState state) {
        return Column(
          children: [
            CustomField(
              text: "Email",
              hintText: "jeo@example.com",
              controller: widget.emailController,
              enabled: (state is LogInLoading) ? false : true,
            ),
            const SizedBox(height: 10.0),
            CustomField(
              text: "Password",
              hintText: "********",
              controller: widget.passwordController,
              enabled: (state is LogInLoading) ? false : true,
              isPassword: true,
            ),
          ],
        );
      },
    );
  }
}

class LogInForgetPasswordButton extends StatelessWidget {
  const LogInForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/forget-password");
        },
        child: Text("Forget Password?"),
      ),
    );
  }
}

class LogInButton extends StatefulWidget {
  const LogInButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<LogInButton> createState() => _LogInButtonState();
}

class _LogInButtonState extends State<LogInButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      builder: (BuildContext context, LogInState state) {
        return ActionButton(
          text: "Log In",
          textColor: Colors.white,
          textSize: 25.0,
          buttonColor: (state is LogInLoading)
              ? AppColors.buttonTextDisabled
              : AppColors.primary,
          onPressed: widget.onPressed,
          isValid: (state is LogInLoading) ? false : true,
          borderColor: AppColors.border,
        );
      },
    );
  }
}

class LogInErrorSection extends StatefulWidget {
  const LogInErrorSection({super.key});

  @override
  State<LogInErrorSection> createState() => _LogInErrorSectionState();
}

class _LogInErrorSectionState extends State<LogInErrorSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      builder: (BuildContext context, LogInState state) {
        return (state is LogInError)
            ? Align(
                alignment: .center,
                child: NormalText(
                  text: state.error,
                  size: 20.0,
                  color: AppColors.error,
                ),
              )
            : const SizedBox();
      },
    );
  }
}

class LogInCircularSection extends StatelessWidget {
  const LogInCircularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      builder: (BuildContext context, LogInState state) {
        return (state is LogInLoading)
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox();
      },
    );
  }
}

class LogInSection extends StatefulWidget {
  const LogInSection({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LogInSection> createState() => _LogInSectionState();
}

class _LogInSectionState extends State<LogInSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const BoldText(
          text: "Sign In",
          size: 30.0,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 5.0),
        const NormalText(
          text: "Welcome back to your civic hub.",
          size: 20.0,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 30.0),
        LogInFormSection(
          emailController: widget.emailController,
          passwordController: widget.passwordController,
        ),
        const LogInForgetPasswordButton(),
        const SizedBox(height: 10.0),
        const LogInErrorSection(),
        const SizedBox(height: 10.0),
        LogInButton(
          onPressed: () {
            context.read<LogInCubit>().logIn(
              widget.emailController.text.trim(),
              widget.passwordController.text.trim(),
            );
          },
        ),
      ],
    );
  }
}

class LogInFooter extends StatelessWidget {
  const LogInFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(),
        Align(
          alignment: .center,
          child: NormalText(
            text: "© 2026 CivicPulse Municipal Systems. All rights reserved.",
            size: 15.0,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
