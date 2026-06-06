import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_actions_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_details_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_state.dart';
import 'package:CivicPulse/features/abuse_report/presentation/screens/admin/component/admin_abuse_report_page_components.dart';
import 'package:CivicPulse/features/abuse_report/presentation/screens/admin/page/admin_abuse_report_details_page.dart';

class AdminAbuseReportsPage extends StatefulWidget {
  const AdminAbuseReportsPage({super.key});

  @override
  State<AdminAbuseReportsPage> createState() => _AdminAbuseReportsPageState();
}

class _AdminAbuseReportsPageState extends State<AdminAbuseReportsPage> {
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AbuseReportCubit>().getAbuseReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AbuseReport> _getFilteredReports(List<AbuseReport> reports) {
    final filtered = reports.where((r) {
      final q = _searchQuery.toLowerCase();
      return r.reportedUserEmail.toLowerCase().contains(q) ||
          r.reportedUserEmail.toLowerCase().contains(q) ||
          r.reason.toLowerCase().contains(q) ||
          r.type.toLowerCase().contains(q);
    }).toList();

    filtered.sort((a, b) => b.createdAtUtc.compareTo(a.createdAtUtc));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<AbuseReportCubit, AbuseReportState>(
                  builder: (context, state) {
                    if (state is AbuseReportLoading) {
                      return _buildLoadingState();
                    }
                    if (state is AbuseReportError) {
                      return _buildErrorState(state.error);
                    }
                    if (state is AbuseReportSuccess) {
                      if (state.abuseReports.isEmpty) {
                        return _buildEmptyState();
                      }
                      final filtered = _getFilteredReports(state.abuseReports);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(),
                          const SizedBox(height: 12),
                          Expanded(
                            child: filtered.isEmpty
                                ? _buildNoResultsState()
                                : ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) => AbuseReportCard(
                                      report: filtered[index],
                                      onViewDetails: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MultiBlocProvider(
                                                providers: [
                                                  BlocProvider(
                                                    create: (context) =>
                                                        sl<
                                                          AbuseReportDetailsCubit
                                                        >(),
                                                  ),
                                                  BlocProvider(
                                                    create: (context) =>
                                                        sl<
                                                          AbuseReportActionsCubit
                                                        >(),
                                                  ),
                                                ],
                                                child:
                                                    AdminAbuseReportDetailsPage(
                                                      id: filtered[index].id,
                                                    ),
                                              );
                                            },
                                          ),
                                        );
                                        context
                                            .read<AbuseReportCubit>()
                                            .getAbuseReports();
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.gavel_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Abuse & Spam Moderation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Review flagged user reports and inspect spam strikes in the moderation queue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.read<AbuseReportCubit>().getAbuseReports(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search by email, reason, or type…',
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: AppColors.textSecondary,
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading moderation queue…',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: AppColors.error,
            ),
            const SizedBox(height: 14),
            const Text(
              'Failed to load reports',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<AbuseReportCubit>().getAbuseReports(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(36),
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 48,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Queue Clear!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No pending abuse reports require admin review.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'No reports match your search',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your search query.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
