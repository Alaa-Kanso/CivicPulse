import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/pages/citizen_home_page.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/pages/create_report_page.dart';

class CitizenNav extends StatelessWidget {
  const CitizenNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/create-report":
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) => sl<CreateReportCubit>(),
                child: const CreateReportPage(),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) => sl<MyReportsCubit>(),
                child: const CitizenHomePage(),
              ),
            );
        }
      },
    );
  }
}
