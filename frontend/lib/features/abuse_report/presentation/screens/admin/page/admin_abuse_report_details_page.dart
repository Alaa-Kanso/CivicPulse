import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_actions_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_actions_state.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_details_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_details_state.dart';
import 'package:CivicPulse/features/abuse_report/presentation/screens/admin/component/admin_abuse_report_details_page_components.dart';

class AdminAbuseReportDetailsPage extends StatefulWidget {
  const AdminAbuseReportDetailsPage({super.key, required this.id});
  
  final String id;

  @override
  State<AdminAbuseReportDetailsPage> createState() =>
      _AdminAbuseReportDetailsPageState();
}

class _AdminAbuseReportDetailsPageState
    extends State<AdminAbuseReportDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadReportDetails();
  }

  void _loadReportDetails() {
    context.read<AbuseReportDetailsCubit>().getReportDetails(id: widget.id);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text(
          'Abuse Report Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
      ),
      body: BlocListener<AbuseReportActionsCubit, AbuseReportActionsState>(
        listener: (context, state) {
          if (state is AbuseReportActionsSuccess) {
            _showSnackBar(state.message);
            Navigator.pop(context);
          } else if (state is AbuseReportActionsFailure) {
            _showSnackBar(state.error, isError: true);
          }
        },
        child: BlocBuilder<AbuseReportDetailsCubit, AbuseReportDetailsState>(
          builder: (context, state) {
            if (state is AbuseReportDetailsLoading ||
                state is AbuseReportDetailsInitial) {
              return const DetailsLoadingShimmer();
            } else if (state is AbuseReportDetailsError) {
              return DetailsErrorState(
                error: state.error,
                onRetry: _loadReportDetails,
              );
            } else if (state is AbuseReportDetailsSuccess) {
              final details = state.reportDetails;

              return RefreshIndicator(
                onRefresh: () async {
                  _loadReportDetails();
                },
                color: AppColors.primary,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  children: [
                    AbuseCaseSummarySection(details: details),
                    const SizedBox(height: 16),
                    ReportedUserSection(details: details),
                    const SizedBox(height: 16),
                    ReportingOperatorSection(details: details),
                    const SizedBox(height: 16),
                    TriggerReportSection(report: details.triggerReport),
                    const SizedBox(height: 16),
                    EvidenceReportsSection(reports: details.evidenceReports),
                    const SizedBox(height: 24),
                    BlocBuilder<AbuseReportActionsCubit, AbuseReportActionsState>(
                      builder: (context, actionState) {
                        final isActionLoading =
                            actionState is AbuseReportActionsLoading;
                        return ModerationActionsSection(
                          reportId: widget.id,
                          isLoading: isActionLoading,
                          onBlockUser: () {
                            context
                                .read<AbuseReportActionsCubit>()
                                .blockUser(id: widget.id);
                          },
                          onDismiss: () {
                            context
                                .read<AbuseReportActionsCubit>()
                                .dismissAbuseReport(id: widget.id);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
