import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/auth/domain/entities/user.dart';
import 'package:CivicPulse/features/operator/presentation/cubit/all_municipalities_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/operator_reports_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Admin/pages/admin_home_page.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/nav/citizen_nav.dart';
import 'package:CivicPulse/features/reports/presentation/screens/operator/pages/operator_home_page.dart';

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
            sl<AllMunicipalitiesCubit>()..getAllMunicipalities(),
        child: const AdminHomePage(),
      );
    }
    if (kIsWeb && user.role == "Operator") {
      return BlocProvider(
        create: (BuildContext context) =>
            sl<OperatorReportsCubit>()..getReportsAndCategoryTypes(),
        child: const OperatorHomePage(),
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
