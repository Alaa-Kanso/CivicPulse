import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:frontend/features/reports/presentation/cubit/rerouting_report_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/rerouting_report_state.dart';
import 'package:frontend/features/reports/presentation/screens/Admin/components/admin_view_rerouting_report_page_component.dart';

class AdminViewReroutingReportPage extends StatelessWidget {
  const AdminViewReroutingReportPage({super.key, required this.report});

  final AdminRerouteReport report;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReroutingReportCubit, ReroutingReportState>(
      listener: (BuildContext context, ReroutingReportState state) {
        if (state is ActionReroutingReportSuccess) {
          Navigator.pop(context);
        }
        if (state is ActionReroutingReportFailure) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        body: BlocBuilder<ReroutingReportCubit, ReroutingReportState>(
          builder: (BuildContext context, ReroutingReportState state) {
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackButton(context),
                        const SizedBox(height: 20),
                        ReportPageHeader(report: report),
                        const SizedBox(height: 28),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 820) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ReportDetailsCard(report: report),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 2,
                                    child: DecisionPanel(
                                      report: report,
                                      isLoading:
                                          (state
                                              is ActionReroutingReportLoading)
                                          ? true
                                          : false,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                ReportDetailsCard(report: report),
                                const SizedBox(height: 24),
                                DecisionPanel(
                                  report: report,
                                  isLoading:
                                      (state is ActionReroutingReportLoading)
                                      ? false
                                      : true,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                (state is ActionReroutingReportLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Back to Queue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
