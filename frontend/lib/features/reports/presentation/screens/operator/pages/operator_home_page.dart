import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/operator_reports_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/operator_reports_state.dart';
import 'package:CivicPulse/features/reports/presentation/screens/operator/components/operator_home_page_component.dart';

class OperatorHomePage extends StatelessWidget {
  const OperatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: (width < 800) ? AppBar(
        title: const Text('Assigned Reports', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ) : null,
      drawer: (width < 800) ? Drawer(child: OperatorFilterSection()) : null,
      body: BlocBuilder<OperatorReportsCubit, OperatorReportsState>(
        builder: (BuildContext context, OperatorReportsState state) {
          if (state is OperatorReportsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is OperatorReportsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoldText(
                    text: state.error,
                    size: 20.0,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<OperatorReportsCubit>()
                          .getReportsAndCategoryTypes();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text("Try Again!"),
                  ),
                ],
              ),
            );
          }
          if (state is OperatorReportsSuccess) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (width >= 800) const OperatorSideBar(),
                const Expanded(child: OperatorViewReportsSection()),
              ],
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BoldText(
                  text: "Something went wrong, please try again",
                  size: 20.0,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<OperatorReportsCubit>()
                        .getReportsAndCategoryTypes();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text("Try Again!"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
