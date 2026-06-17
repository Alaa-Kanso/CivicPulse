import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/Component/components.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:CivicPulse/features/reports/domain/entities/report_details.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_state.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/pages/details_page.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 36.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }
}

class CitizenReportStats extends StatefulWidget {
  const CitizenReportStats({
    super.key,
    required this.totalReports,
    required this.inProgressReports,
  });

  final int totalReports;
  final int inProgressReports;

  @override
  State<CitizenReportStats> createState() => _CitizenReportStatsState();
}

class _CitizenReportStatsState extends State<CitizenReportStats> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.totalReports.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Total Reports",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.border.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.pending_actions_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.inProgressReports.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  "In Progress",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = getStatusColor(status);
    final Color backgroundColor = baseColor.withOpacity(0.12);
    final Color textColor = baseColor.withOpacity(0.9);

    String label = status;
    if (status == "InProgress") {
      label = "In Progress";
    } else if (status == "InReview") {
      label = "In Review";
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class ReportCard extends StatefulWidget {
  const ReportCard({super.key, required this.report});

  final ReportDetails report;

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  String _formatDate(DateTime date) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final localDate = date.toLocal();
    return "${months[localDate.month - 1]} ${localDate.day}, ${localDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(report: widget.report),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.border.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                height: 90,
                width: 90,
                child: Image.network(
                  "${widget.report.imageUrl}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.surfaceLight,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.textMuted,
                        size: 28,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.surfaceLight,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusPill(status: widget.report.status),
                      Text(
                        _formatDate(widget.report.createdAtUtc),
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.report.reportTypeName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 15.0,
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          widget.report.location,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyReportHeader extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const MyReportHeader({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "My Reports",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
        ),
        InkWell(
          onTap: onFilterTap ?? () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.filter_list_rounded,
                  size: 16.0,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.0),
                Text(
                  "Filter",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Submitted":
      return const Color(0xFFF59E0B); // warning amber
    case "InReview":
      return const Color(0xFF3B82F6); // info blue
    case "InProgress":
      return const Color(0xFFEF4444); // orange/red
    case "Resolved":
      return const Color(0xFF10B981); // success green
    case "Rejected":
      return const Color(0xFF6B7280); // gray
    default:
      return Colors.grey;
  }
}

class ReportFilterBottomSheet extends StatefulWidget {
  const ReportFilterBottomSheet({super.key});

  @override
  State<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState extends State<ReportFilterBottomSheet> {
  List<String> categoryFilter = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BoldText(
                    text: "Filter Catalog",
                    size: 18.0,
                    color: Colors.black,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MyReportsCubit>().clearFilters();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const NormalText(
                    text: "FILTER BY STATUS",
                    size: 15.0,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 10.0),
                  BlocBuilder<MyReportsCubit, MyReportsState>(
                    builder: (BuildContext context, MyReportsState state) {
                      if (state is MyReportsSuccess) {
                        return Column(
                          children: [
                            FilterContainer(
                              text: "In Review",
                              selected: state.statusFilter.contains("InReview"),
                              onChange: () {
                                context
                                    .read<MyReportsCubit>()
                                    .addOrRemoveStatusFilter("InReview");
                              },
                            ),
                            FilterContainer(
                              text: "In Progress",
                              selected: state.statusFilter.contains(
                                "InProgress",
                              ),
                              onChange: () {
                                context
                                    .read<MyReportsCubit>()
                                    .addOrRemoveStatusFilter("InProgress");
                              },
                            ),
                            FilterContainer(
                              text: "Rejected",
                              selected: state.statusFilter.contains("Rejected"),
                              onChange: () {
                                context
                                    .read<MyReportsCubit>()
                                    .addOrRemoveStatusFilter("Rejected");
                              },
                            ),
                            FilterContainer(
                              text: "Resolved",
                              selected: state.statusFilter.contains("Resolved"),
                              onChange: () {
                                context
                                    .read<MyReportsCubit>()
                                    .addOrRemoveStatusFilter("Resolved");
                              },
                            ),
                            const Divider(height: 1, color: AppColors.border),
                            const SizedBox(height: 10.0),
                            const NormalText(
                              text: "FILTER BY CATEGORY",
                              size: 15.0,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 10.0),
                            Column(
                              children: state.reportTypes.map((type) {
                                return FilterContainer(
                                  text: type.name,
                                  selected: state.categoryFilter.contains(
                                    type.id,
                                  ),
                                  onChange: () {
                                    context
                                        .read<MyReportsCubit>()
                                        .addOrRemoveCategoryFilter(type.id);
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10.0),
                            ActionButton(
                              text: "Apply Filter",
                              textColor: Colors.white,
                              textSize: 18.0,
                              buttonColor: AppColors.primary,
                              onPressed: () {
                                context.read<MyReportsCubit>().applyFilter();
                                Navigator.pop(context);
                              },
                              borderColor: AppColors.border,
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterContainer extends StatelessWidget {
  const FilterContainer({
    super.key,
    required this.text,
    required this.selected,
    required this.onChange,
  });

  final String text;
  final bool selected;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NormalText(text: text, size: 15.0, color: AppColors.textPrimary),
        Checkbox(
          value: selected,
          onChanged: (value) {
            onChange();
          },
        ),
      ],
    );
  }
}
