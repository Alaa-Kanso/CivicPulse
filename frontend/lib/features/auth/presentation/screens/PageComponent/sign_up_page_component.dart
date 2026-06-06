import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/sign_up_state.dart';

class SignUpMobileHeader extends StatelessWidget {
  const SignUpMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: .circular(10),
          ),
          padding: .all(10.0),
          child: Icon(
            Icons.account_balance_outlined,
            color: AppColors.primary,
            size: 50.0,
          ),
        ),
        const SizedBox(height: 5.0),
        BoldText(text: "Create Account", size: 30.0, color: Colors.black87),
        NormalText(
          text:
              "Help improve your community by reporting local issues like potholes or broken streetlights.",
          size: 20.0,
          color: Colors.black54,
          textAlign: .center,
        ),
      ],
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        return Column(
          children: [
            CustomField(
              text: "Email",
              hintText: "Joe@example.com",
              controller: widget.emailController,
              enabled: (state is SignUpLoading)?false:true,

            ),
            const SizedBox(height: 10.0),
            CustomField(
              text: "Password",
              hintText: "********",
              controller: widget.passwordController,
              enabled: (state is SignUpLoading)?false:true,
              isPassword: true,
            ),
            const SizedBox(height: 10.0),
            CustomField(
              text: "Confirm Password",
              hintText: "********",
              controller: widget.confirmPasswordController,
              enabled: (state is SignUpLoading)?false:true,
              isPassword: true,
            ),
          ],
        );
      },
    );
  }
}

class SignUpErrorSection extends StatelessWidget {
  const SignUpErrorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        return (state is SignUpError)
            ? NormalText(text: state.error, size: 20.0, color: AppColors.error)
            : SizedBox();
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        return ActionButton(
          text: "Sign Up",
          textColor: Colors.white,
          textSize: 25.0,
          buttonColor: (state is SignUpLoading)
              ? AppColors.buttonTextDisabled
              : AppColors.primary,
          onPressed: onPressed,
          borderColor: AppColors.border,
          isValid: (state is SignUpLoading) ? false : true,
        );
      },
    );
  }
}
