import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/operator/domain/entities/municipality.dart';
import 'package:CivicPulse/features/operator/presentation/cubit/assigned_municipalities_cubit.dart';
import 'package:CivicPulse/features/operator/presentation/cubit/assigned_municipalities_state.dart';
import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/rerouting_report_cubit.dart';

class ReportPageHeader extends StatelessWidget {
  const ReportPageHeader({super.key, required this.report});

  final AdminRerouteReport report;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
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
              Icons.assignment_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.reportTypeName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review this report and decide how to proceed.',
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
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pending_rounded, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportDetailsCard extends StatelessWidget {
  const ReportDetailsCard({super.key, required this.report});

  final AdminRerouteReport report;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminViewReroutingImageSection(imageUrl: report.imageKey),

          //TODO: change to image URL
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminViewReroutingTitleSection(title: "Report Information"),
                const SizedBox(height: 14),

                AdminViewReroutingRowInfoSection(
                  icon: Icons.category_rounded,
                  label: 'Type',
                  value: report.reportTypeName,
                ),
                const SizedBox(height: 10),
                AdminViewReroutingRowInfoSection(
                  icon: Icons.calendar_today_rounded,
                  label: 'Submitted',
                  value: _formatDate(report.createdAtUtc),
                ),
                const SizedBox(height: 10),
                AdminViewReroutingRowInfoSection(
                  icon: Icons.fingerprint_rounded,
                  label: 'Report ID',
                  value: report.id,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Divider(height: 1, color: AppColors.border),
                ),

                AdminViewReroutingTitleSection(title: "Location"),
                const SizedBox(height: 14),

                AdminViewReroutingRowInfoSection(
                  icon: Icons.location_on_outlined,
                  label: 'Municipality',
                  value: report.municipalityName ?? 'Outside Lebanon',
                  valueColor: AppColors.primary,
                ),
                if (report.originalMunicipalityName != null) ...[
                  const SizedBox(height: 10),
                  AdminViewReroutingRowInfoSection(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Originally Assigned',
                    value: report.originalMunicipalityName!,
                    valueColor: AppColors.warning,
                  ),
                ],
                if (report.addressDetails != null &&
                    report.addressDetails!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  AdminViewReroutingRowInfoSection(
                    icon: Icons.place_outlined,
                    label: 'Address',
                    value: report.addressDetails!,
                  ),
                ],
                const SizedBox(height: 10),
                AdminViewReroutingRowInfoSection(
                  icon: Icons.my_location_rounded,
                  label: 'Coordinates',
                  value:
                      '${report.latitude.toStringAsFixed(5)}, ${report.longitude.toStringAsFixed(5)}',
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Divider(height: 1, color: AppColors.border),
                ),

                AdminViewReroutingTitleSection(title: "Description"),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    report.description.isNotEmpty
                        ? report.description
                        : 'No description provided.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Divider(height: 1, color: AppColors.border),
                ),

                AdminViewReroutingTitleSection(title: 'Admin Routing Reason'),

                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          report.adminRoutingReason,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary.withValues(
                              alpha: 0.85,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour:$minute';
  }
}

class DecisionPanel extends StatefulWidget {
  const DecisionPanel({
    super.key,
    required this.report,
    required this.isLoading,
  });

  final AdminRerouteReport report;
  final bool isLoading;

  @override
  State<DecisionPanel> createState() => _DecisionPanelState();
}

class _DecisionPanelState extends State<DecisionPanel> {
  bool _showDeleteConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRerouteSection(isLoading: widget.isLoading),
        const SizedBox(height: 20),
        _buildDeleteSection(
          reportId: widget.report.id,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }

  // ── Reroute Section ──
  Widget _buildRerouteSection({required bool isLoading}) {
    int? municipalityId;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.alt_route_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Re-route Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Assign to the correct municipality',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Current assignment info
          if (widget.report.municipalityName != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_city_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Current: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.report.municipalityName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const Text(
            'New Municipality',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<AssignedMunicipalitiesCubit, AssignedMunicipalitiesState>(
            builder: (BuildContext context, AssignedMunicipalitiesState state) {
              List<Municipality> municipalities = [];
              if (state is AssignedMunicipalitiesSuccess) {
                municipalities = state.municipalities;
              }
              return IgnorePointer(
                ignoring: isLoading,
                child: Autocomplete<Municipality>(
                  displayStringForOption: (option) => option.name,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    // Show all when empty
                    if (textEditingValue.text.isEmpty) {
                      return municipalities;
                    }

                    return municipalities.where(
                      (municipality) => municipality.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()),
                    );
                  },

                  onSelected: (option) {
                    municipalityId = option.id;
                  },

                  fieldViewBuilder:
                      (
                        context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,

                          decoration: InputDecoration(
                            hintText: "Choose municipality",

                            prefixIcon: const Icon(Icons.location_city),
                            suffixIcon: state is AssignedMunicipalitiesLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : state is AssignedMunicipalitiesFailure
                                ? Tooltip(
                                    message: state.error,
                                    child: const Icon(Icons.error_outline),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 300,
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);

                              return ListTile(
                                title: Text(option.name),
                                onTap: () {
                                  onSelected(option);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Re-route button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: (isLoading)
                  ? null
                  : () {
                      // TODO: implement reroute action
                      context.read<ReroutingReportCubit>().rerouteReport(
                        reportId: widget.report.id,
                        municipalityId: municipalityId,
                      );
                    },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Re-route Report',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: (isLoading)
                    ? AppColors.buttonTextDisabled
                    : AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteSection({
    required String reportId,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _showDeleteConfirm
              ? AppColors.error.withValues(alpha: 0.4)
              : AppColors.border.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Permanently remove this report',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (!_showDeleteConfirm) ...[
            // Initial delete button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: (isLoading)
                    ? null
                    : () {
                        setState(() => _showDeleteConfirm = true);
                      },
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text(
                  'Delete Report',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: (isLoading)
                      ? AppColors.buttonTextDisabled
                      : AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Confirmation state
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 28,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Are you sure?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This action cannot be undone.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _showDeleteConfirm = false);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: (isLoading)
                                ? null
                                : () {
                                    // TODO: implement delete action
                                    context
                                        .read<ReroutingReportCubit>()
                                        .deleteReport(reportId: reportId);
                                  },
                            icon: const Icon(
                              Icons.delete_forever_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AdminViewReroutingImageSection extends StatelessWidget {
  const AdminViewReroutingImageSection({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surfaceLight,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 42,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Image unavailable',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AdminViewReroutingTitleSection extends StatelessWidget {
  const AdminViewReroutingTitleSection({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }
}

class AdminViewReroutingRowInfoSection extends StatelessWidget {
  const AdminViewReroutingRowInfoSection({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
