import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/reports/domain/entities/operator_report.dart';
import 'package:frontend/features/reports/domain/entities/report_type.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_manager_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_report_details_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_reports_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_reports_state.dart';
import 'package:frontend/features/reports/presentation/screens/operator/pages/operator_report_details_page.dart';

class OperatorSideBar extends StatelessWidget {
  const OperatorSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const OperatorFilterSection(),
    );
  }
}

class OperatorFilterSection extends StatelessWidget {
  const OperatorFilterSection({super.key});

  static const statuses = [
    ('Submitted', 'Submitted'),
    ('InReview', 'In Review'),
    ('InProgress', 'In Progress'),
    ('Resolved', 'Resolved'),
    ('Rejected', 'Rejected'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperatorReportsCubit, OperatorReportsState>(
      builder: (context, state) {
        List<ReportType> reportTypes = [];
        List<String> statusFilter = [];
        List<int> reportTypeFilter = [];

        if (state is OperatorReportsSuccess) {
          reportTypes = state.reportTypes;
          statusFilter = state.statusFilter;
          reportTypeFilter = state.reportTypeFilter;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.filter_list,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const BoldText(
                            text: "Filters",
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const BoldText(
                        text: "Status",
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: statuses
                            .map(
                              (status) => FilterChipWidget(
                                isChecked: statusFilter.contains(status.$1),
                                text: status.$2,
                                onTap: () {
                                  context
                                      .read<OperatorReportsCubit>()
                                      .filterByStatus(status.$1);
                                },
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 24),

                      const BoldText(
                        text: "Report Type",
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: 12),

                      if (reportTypes.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: reportTypes
                              .map(
                                (e) => FilterChipWidget(
                                  isChecked: reportTypeFilter.contains(e.id),
                                  text: e.name,
                                  onTap: () {
                                    context
                                        .read<OperatorReportsCubit>()
                                        .filterByReportType(e.id);
                                  },
                                ),
                              )
                              .toList(),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.isChecked,
    required this.text,
    required this.onTap,
  });

  final bool isChecked;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isChecked
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isChecked ? AppColors.primary : AppColors.border,
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isChecked ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class OperatorViewReportsSection extends StatelessWidget {
  const OperatorViewReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoldText(
                          text: "Assigned Reports",
                          size: 28.0,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(height: 8.0),
                        NormalText(
                          text: "Review and manage reports assigned to you.",
                          size: 16.0,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: SearchBar(
                      hintText: "Search by report ID...",
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: const MaterialStatePropertyAll(
                        AppColors.background,
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      leading: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      onChanged: (value) {
                        context.read<OperatorReportsCubit>().filterById(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      context
                          .read<OperatorReportsCubit>()
                          .getReportsAndCategoryTypes();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.textPrimary,
                    ),
                    tooltip: 'Refresh Reports',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              BlocBuilder<OperatorReportsCubit, OperatorReportsState>(
                builder: (BuildContext context, OperatorReportsState state) {
                  List<OperatorReport> reports = [];
                  if (state is OperatorReportsSuccess) {
                    reports = state.reports;
                  }
                  if (state is OperatorReportsLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (reports.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 380,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      return _buildReportCard(reports[index], context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const BoldText(
              text: "No reports assigned",
              size: 24.0,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            const NormalText(
              text: "New reports assigned to you will appear here.",
              size: 16.0,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(OperatorReport e, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  e.reportTypeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _StatusChip(status: e.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  e.municipalityName,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              e.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(e.createdAtUtc),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) =>
                                  sl<OperatorReportDetailsCubit>()
                                    ..getReportDetails(id: e.id),
                            ),
                            BlocProvider(
                              create: (_) => sl<OperatorManagerCubit>(),
                            ),
                          ],
                          child: OperatorReportDetailsPage(id: e.id),
                        ),
                      ),
                    );
                    context.read<OperatorReportsCubit>().getReportsAndCategoryTypes();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "View",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toLowerCase()) {
      case "submitted":
        color = const Color(0xFFF59E0B); // warning amber
      case "inreview":
        color = const Color(0xFF3B82F6); // info blue
      case "inprogress":
        color = const Color(0xFFEF4444); // orange/red
      case "resolved":
        color = const Color(0xFF10B981); // success green
      case "rejected":
        color = const Color(0xFF6B7280); // gray
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
