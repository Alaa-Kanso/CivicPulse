import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/reports/presentation/screens/Citizen/nav/citizen_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {

    if (!kIsWeb && user.role == "Citizen") {
      return const CitizenNav();
    }
    if (kIsWeb && user.role == "Admin") {
      return Container();
    }
    return Scaffold(
      body: Center(
        child: BoldText(
          text: "Something went wrong, please restart the app",
          size: 30.0,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
