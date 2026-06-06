import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_manager_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_manager_state.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_report_details_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_report_details_state.dart';
import 'package:frontend/features/reports/presentation/screens/operator/components/operator_report_detail_page_component.dart';

class OperatorReportDetailsPage extends StatelessWidget {
  const OperatorReportDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OperatorManagerCubit, OperatorManagerState>(
      listener: (BuildContext context, OperatorManagerState state) {
        if (state is OperatorManagerSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        if(state is OperatorManagerFailure){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
               backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        body: BlocBuilder<OperatorReportDetailsCubit, OperatorReportDetailsState>(
          builder: (context, state) {
            if (state is OperatorReportDetailsLoading) {
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border.withOpacity(0.5),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: OperatorDetailLoadingState()),
                  ],
                ),
              );
            }

            if (state is OperatorReportDetailsError) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border.withOpacity(0.5),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      OperatorDetailErrorState(
                        error: state.error,
                        onRetry: () {
                          context
                              .read<OperatorReportDetailsCubit>()
                              .getReportDetails(id: id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is OperatorReportDetailsSuccess) {
              final report = state.reportDetails;

              return SafeArea(
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 900;

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 40 : 20,
                            vertical: 24,
                          ),
                          child: BlocBuilder<OperatorManagerCubit, OperatorManagerState>(
                            builder: (BuildContext context, OperatorManagerState state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Header ──
                                  OperatorDetailHeader(
                                    reportId: report.id,
                                    status: report.status,
                                  ),
                                  const SizedBox(height: 28),

                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              OperatorReportInfoCard(
                                                report: report,
                                              ),
                                              const SizedBox(height: 20),
                                              OperatorDescriptionCard(
                                                description: report.description,
                                              ),
                                              const SizedBox(height: 20),
                                              OperatorLocationCard(
                                                addressDetails:
                                                    report.addressDetails,
                                                latitude: report.latitude,
                                                longitude: report.longitude,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              OperatorImagePreviewCard(
                                                imageUrl: report.imageUrl,
                                              ),
                                              const SizedBox(height: 20),
                                              OperatorModerationActionsCard(
                                                report: report,
                                                onStatusChanged: (newStatus) {
                                                  _showStatusChangeConfirmation(
                                                    context,
                                                    report.id,
                                                    newStatus,
                                                  );
                                                },
                                                onEscalate: () {
                                                  _showEscalateConfirmation(
                                                    context,
                                                    report.id,
                                                  );
                                                },
                                                onMarkAsSpam: () {
                                                  _showSpamConfirmation(
                                                    context,
                                                    report.id,
                                                  );
                                                },
                                                isLoading:
                                                    (state
                                                        is OperatorManagerLoading)
                                                    ? true
                                                    : false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        OperatorImagePreviewCard(
                                          imageUrl: report.imageUrl,
                                        ),
                                        const SizedBox(height: 20),
                                        OperatorReportInfoCard(report: report),
                                        const SizedBox(height: 20),
                                        OperatorDescriptionCard(
                                          description: report.description,
                                        ),
                                        const SizedBox(height: 20),
                                        OperatorLocationCard(
                                          addressDetails: report.addressDetails,
                                          latitude: report.latitude,
                                          longitude: report.longitude,
                                        ),
                                        const SizedBox(height: 20),
                                        OperatorModerationActionsCard(
                                          report: report,
                                          onStatusChanged: (newStatus) {
                                            _showStatusChangeConfirmation(
                                              context,
                                              report.id,
                                              newStatus,
                                            );
                                          },
                                          onEscalate: () {
                                            _showEscalateConfirmation(
                                              context,
                                              report.id,
                                            );
                                          },
                                          onMarkAsSpam: () {
                                            _showSpamConfirmation(
                                              context,
                                              report.id,
                                            );
                                          },
                                          isLoading:
                                              (state is OperatorManagerLoading)
                                              ? true
                                              : false,
                                        ),
                                        const SizedBox(height: 32),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                    (state is OperatorManagerLoading)
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox(),
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

  void _showStatusChangeConfirmation(
    BuildContext context,
    String reportId,
    String newStatus,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Change Status",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Are you sure you want to change the status to \"${_formatStatusLabel(newStatus)}\"?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<OperatorManagerCubit>().changeStatus(
                reportId: reportId,
                status: _formatStatusLabel(newStatus),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showEscalateConfirmation(BuildContext context, String reportId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.trending_up_rounded, color: AppColors.warning, size: 24),
            const SizedBox(width: 10),
            const Text(
              "Escalate Report",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "This will escalate the report for manual admin review. Please provide a reason.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              maxLength: 250,
              decoration: InputDecoration(
                hintText: "Enter escalation reason...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () async {
              final reason = reasonController.text.trim();

              Navigator.pop(dialogContext);

              await context.read<OperatorManagerCubit>().markAsEscalate(
                reportId: reportId,
                reason: reason,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Escalate"),
          ),
        ],
      ),
    );
  }

  void _showSpamConfirmation(BuildContext context, String reportId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.report_gmailerrorred_rounded,
              color: AppColors.error,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              "Mark as Spam",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "This will flag the report as spam. This action may affect the reporter's account. Please provide a reason.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter spam reason...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () async {
              final reason = reasonController.text.trim();

              Navigator.pop(dialogContext);
              await context.read<OperatorManagerCubit>().markAsSpam(
                reportId: reportId,
                reason: reason,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Mark as Spam"),
          ),
        ],
      ),
    );
  }

  String _formatStatusLabel(String status) {
    switch (status) {
      case "InProgress":
        return "In Progress";
      case "InReview":
        return "In Review";
      default:
        return status;
    }
  }
}
