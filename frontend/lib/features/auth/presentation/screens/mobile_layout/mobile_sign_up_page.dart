import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:frontend/features/auth/presentation/cubit/sign_up_state.dart';
import 'package:frontend/features/auth/presentation/screens/PageComponent/sign_up_page_component.dart';

class MobileSignUpPage extends StatefulWidget {
  const MobileSignUpPage({super.key});

  @override
  State<MobileSignUpPage> createState() => _MobileSignUpPageState();
}

class _MobileSignUpPageState extends State<MobileSignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit,SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if(state is SignUpSuccess){
          context.read<AuthCubit>();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: NormalText(
              text: "Join CivicPulse",
              size: 20.0,
              color: AppColors.textPrimary,
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SignUpMobileHeader(),
                        const SizedBox(height: 10.0),
                        SignUpForm(
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                        ),
                        const SizedBox(height: 10.0),
                        const SignUpErrorSection(),
                        const SizedBox(height: 10.0),
                        SignUpButton(
                          onPressed: () {
                            context.read<SignUpCubit>().signUp(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              confirmPasswordController.text.trim(),
                            );
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Wrap(
                          crossAxisAlignment: .center,
                          alignment: .center,
                          children: [
                            NormalText(
                              text: "Already have an account?",
                              size: 15.0,
                              color: AppColors.textSecondary,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "/log-in");
                              },
                              child: Text(
                                "Log In",
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (BuildContext context, SignUpState state) {
                  return (state is SignUpLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
