import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/operator/presentation/cubit/get_municipalities_cubit.dart';
import 'package:frontend/features/reports/presentation/screens/Admin/pages/admin_home_page.dart';
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
      return BlocProvider(
        create: (BuildContext context) =>
            sl<GetMunicipalitiesCubit>()..getMunicipalities(),
        child: const AdminHomePage(),
      );
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
