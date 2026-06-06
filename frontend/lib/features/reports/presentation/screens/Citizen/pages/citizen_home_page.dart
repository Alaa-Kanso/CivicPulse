import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/core/session/session_manager.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_state.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/components/citizen_page_component.dart';

class CitizenHomePage extends StatefulWidget {
  const CitizenHomePage({super.key});

  @override
  State<CitizenHomePage> createState() => _CitizenHomePageState();
}

class _CitizenHomePageState extends State<CitizenHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<MyReportsCubit>().getMyReports();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = sl<SessionManager>().user?.email ?? "Citizen";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: Drawer(elevation: 0, child: DrawerSection(email: userEmail)),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CivicPulse",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.primary,
            size: 28.0,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: BlocBuilder<MyReportsCubit, MyReportsState>(
          builder: (BuildContext context, MyReportsState state) {
            if (state is MyReportsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading your reports...",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is MyReportsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Failed to load reports",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.error,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<MyReportsCubit>().getMyReports();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                          ),
                          child: const Text("Try Again"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is MyReportsSuccess) {
              final reports = state.myReports;
              final inProgressCount = reports
                  .where((element) => element.status == "InProgress")
                  .length;

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: reports.isEmpty ? 2 : reports.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        CitizenReportStats(
                          totalReports: reports.length,
                          inProgressReports: inProgressCount,
                        ),
                        const SizedBox(height: 24.0),
                        MyReportHeader(
                          onFilterTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<MyReportsCubit>(),
                                  child: const ReportFilterBottomSheet(),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 14.0),
                      ],
                    );
                  }

                  if (reports.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 36.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.04),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_late_outlined,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "No reports yet",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Spotted an issue in your municipality? File a report to help us resolve it quickly.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                "/create-report",
                              );
                              if (mounted) {
                                context.read<MyReportsCubit>().getMyReports();
                              }
                            },
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text("Create Report"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final report = reports[index - 1];
                  return ReportCard(report: report);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "/create-report");
          if (mounted) {
            context.read<MyReportsCubit>().getMyReports();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
