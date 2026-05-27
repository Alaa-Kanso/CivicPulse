import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_state.dart';
import 'package:frontend/features/operator/presentation/screens/admin/components/admin_create_operator_page_components.dart';

class AdminCreateOperatorPage extends StatefulWidget {
  const AdminCreateOperatorPage({super.key});

  @override
  State<AdminCreateOperatorPage> createState() =>
      _AdminCreateOperatorPageState();
}

class _AdminCreateOperatorPageState extends State<AdminCreateOperatorPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOperatorCubit, CreateOperatorState>(
      listener: (BuildContext context, CreateOperatorState state) {
        if (state is CreateOperatorSuccess) {
          CreateOperatorResultDialog.showOperatorDialog(
            context: context,
            success: true,
            message: "The operator account has been created successfully.",
          );
        }
        if (state is CreateOperatorFailure) {
          CreateOperatorResultDialog.showOperatorDialog(
            context: context,
            success: false,
            message: state.error,
          );
        }
      },
      child: BlocBuilder<CreateOperatorCubit, CreateOperatorState>(
        builder: (BuildContext context, CreateOperatorState state) {
          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .start,
                      children: [
                        const BoldText(
                          text: "Register New Operator",
                          size: 30.0,
                          color: AppColors.textPrimary,
                        ),
                        const NormalText(
                          text: "Create a new administrative operator account.",
                          size: 20.0,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 10.0),
                        CreateOperatorForm(
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (state is CreateOperatorLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
