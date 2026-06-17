import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16.0),
    border: Border.all(color: AppColors.border.withOpacity(0.4)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Widget _sectionLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
      letterSpacing: 0.8,
    ),
  );
}

String _formatDate(DateTime date) {
  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  final localDate = date.toLocal();
  final hour = localDate.hour == 0
      ? 12
      : (localDate.hour > 12 ? localDate.hour - 12 : localDate.hour);
  final period = localDate.hour >= 12 ? "PM" : "AM";
  final minute = localDate.minute.toString().padLeft(2, '0');
  return "${months[localDate.month - 1]} ${localDate.day}, ${localDate.year} at $hour:$minute $period";
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case "submitted":
      return const Color(0xFFF59E0B);
    case "inreview":
      return const Color(0xFF3B82F6);
    case "inprogress":
      return const Color(0xFFEF4444);
    case "resolved":
      return const Color(0xFF10B981);
    case "rejected":
      return const Color(0xFF6B7280);
    default:
      return Colors.grey;
  }
}

String _statusLabel(String status) {
  switch (status) {
    case "InProgress":
      return "In Progress";
    case "InReview":
      return "In Review";
    default:
      return status;
  }
}

class OperatorDetailHeader extends StatelessWidget {
  final String reportId;
  final String status;

  const OperatorDetailHeader({
    super.key,
    required this.reportId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "ID: ${reportId.length > 12 ? '${reportId.substring(0, 12)}…' : reportId}",
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                _statusLabel(status),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OperatorReportInfoCard extends StatelessWidget {
  final OperatorReportDetails report;

  const OperatorReportInfoCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("REPORT INFORMATION"),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.category_rounded,
            label: "Type",
            value: report.reportTypeName,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.location_city_rounded,
            label: "Municipality",
            value: report.municipalityName,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: "Created",
            value: _formatDate(report.createdAtUtc),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.update_rounded,
            label: "Last Updated",
            value: _formatDate(report.updatedAtUtc),
          ),

          // ── Spam Warning Banner ──
          if (report.isSpam) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_gmailerrorred_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Flagged as Spam",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                        if (report.spamReason != null &&
                            report.spamReason!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            report.spamReason!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.error.withOpacity(0.75),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (report.hasPendingManualEscalation) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withOpacity(0.25)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.escalator_warning_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Pending manual escalation review",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (report.reportedUserUnderReview) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.info.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.person_search_rounded,
                    color: AppColors.info,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Reported user is currently under review",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OperatorDescriptionCard extends StatelessWidget {
  final String description;

  const OperatorDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              _sectionLabel("DESCRIPTION"),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class OperatorLocationCard extends StatefulWidget {
  final String addressDetails;
  final double latitude;
  final double longitude;

  const OperatorLocationCard({
    super.key,
    required this.addressDetails,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<OperatorLocationCard> createState() => _OperatorLocationCardState();
}

class _OperatorLocationCardState extends State<OperatorLocationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.border.withOpacity(0.4),
                width: 1.0,
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child: SizedBox(
                    height: 400,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(33.8547, 35.8623),
                        zoom: 8.2,
                      ),
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      cameraTargetBounds: CameraTargetBounds(
                        LatLngBounds(
                          southwest: const LatLng(33.055, 35.095),
                          northeast: const LatLng(34.691, 36.625),
                        ),
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: LatLng(widget.latitude, widget.longitude),
                        ),
                      },
                      minMaxZoomPreference: const MinMaxZoomPreference(9, 23),
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _sectionLabel("LOCATION"),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.addressDetails.isNotEmpty
                      ? widget.addressDetails
                      : "No address details",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _CoordinateChip(
                      icon: Icons.north_rounded,
                      label: "Lat",
                      value: widget.latitude.toStringAsFixed(5),
                    ),
                    const SizedBox(width: 8),
                    _CoordinateChip(
                      icon: Icons.east_rounded,
                      label: "Lng",
                      value: widget.longitude.toStringAsFixed(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A CustomPainter that draws a beautiful stylized vector map simulation as background.
class _MapVisualPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 1. Background Land (soft pastel yellow-gray/beige)
    paint.color = const Color(0xFFF4F3F0);
    canvas.drawRect(Offset.zero & size, paint);

    // 2. Green Park Area
    paint.color = const Color(0xFFE1F0D4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.1,
          size.width * 0.35,
          size.height * 0.5,
        ),
        const Radius.circular(16),
      ),
      paint,
    );

    // Another green area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.65,
          size.height * 0.05,
          size.width * 0.25,
          size.height * 0.35,
        ),
        const Radius.circular(16),
      ),
      paint,
    );

    // 3. Water body / River (smooth curved line)
    paint.color = const Color(0xFFC4E0E5);
    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.82);
    riverPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.72,
      size.width * 0.6,
      size.height * 0.9,
    );
    riverPath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 1.05,
      size.width,
      size.height * 0.88,
    );
    riverPath.lineTo(size.width, size.height);
    riverPath.lineTo(0, size.height);
    riverPath.close();
    canvas.drawPath(riverPath, paint);

    // 4. Main Roads (White wide strokes)
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    // Horizontal Road
    paint.strokeWidth = 22.0;
    canvas.drawLine(
      Offset(-20, size.height * 0.5),
      Offset(size.width + 20, size.height * 0.5),
      paint,
    );

    // Vertical Road
    paint.strokeWidth = 18.0;
    canvas.drawLine(
      Offset(size.width * 0.55, -20),
      Offset(size.width * 0.55, size.height + 20),
      paint,
    );

    // Secondary diagonal road
    paint.strokeWidth = 12.0;
    canvas.drawLine(
      Offset(-10, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.85),
      paint,
    );

    // 5. Road Outlines/Borders (beige/grey)
    paint.color = const Color(0xFFE8E6E0);
    paint.strokeWidth = 1.5;

    // Horizontal road borders
    canvas.drawLine(
      Offset(-20, size.height * 0.5 - 11),
      Offset(size.width + 20, size.height * 0.5 - 11),
      paint,
    );
    canvas.drawLine(
      Offset(-20, size.height * 0.5 + 11),
      Offset(size.width + 20, size.height * 0.5 + 11),
      paint,
    );

    // Vertical road borders
    canvas.drawLine(
      Offset(size.width * 0.55 - 9, -20),
      Offset(size.width * 0.55 - 9, size.height + 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.55 + 9, -20),
      Offset(size.width * 0.55 + 9, size.height + 20),
      paint,
    );

    // 6. Target ring beneath marker
    paint.style = PaintingStyle.fill;
    paint.color = AppColors.primary.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 32.0, paint);
    paint.color = AppColors.primary.withOpacity(0.18);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 16.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Small chip showing a single coordinate value.
class _CoordinateChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CoordinateChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontFamily: "monospace",
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// IMAGE PREVIEW CARD
// ═══════════════════════════════════════════════════════════════════════════════

class OperatorImagePreviewCard extends StatelessWidget {
  final String? imageUrl;

  const OperatorImagePreviewCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                _sectionLabel("ATTACHMENT"),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 220,
              child: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.surfaceLight,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryLight,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : _buildPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppColors.textMuted,
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            "No attachment provided",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODERATION ACTIONS CARD
// ═══════════════════════════════════════════════════════════════════════════════

class OperatorModerationActionsCard extends StatelessWidget {
  final OperatorReportDetails report;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onEscalate;
  final VoidCallback onMarkAsSpam;
  final bool isLoading;

  const OperatorModerationActionsCard({
    super.key,
    required this.report,
    required this.onStatusChanged,
    required this.onEscalate,
    required this.onMarkAsSpam,
    required this.isLoading,
  });

  static const _statuses = [
    ('Submitted', 'Submitted', Icons.outbox_rounded),
    ('InReview', 'In Review', Icons.rate_review_rounded),
    ('InProgress', 'In Progress', Icons.engineering_rounded),
    ('Resolved', 'Resolved', Icons.check_circle_outline_rounded),
    ('Rejected', 'Rejected', Icons.cancel_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              _sectionLabel("MODERATION ACTIONS"),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Change Status",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((s) {
              final isActive = report.status == s.$1;
              final color = _statusColor(s.$1);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isActive
                      ? null
                      : (isLoading)
                      ? null
                      : () => onStatusChanged(s.$1),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? color.withOpacity(0.12)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? color.withOpacity(0.4)
                            : AppColors.border.withOpacity(0.5),
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s.$3,
                          size: 16,
                          color: isActive ? color : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          s.$2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive ? color : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),

          // ── Quick Actions ──
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // Escalate
              Expanded(
                child: _ActionButton(
                  icon: Icons.trending_up_rounded,
                  label: "Escalate Report",
                  color: AppColors.warning,
                  onTap: onEscalate,
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(width: 12),
              // Mark as Spam
              Expanded(
                child: _ActionButton(
                  icon: Icons.report_gmailerrorred_rounded,
                  label: "Mark as Spam",
                  color: AppColors.error,
                  onTap: onMarkAsSpam,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (isLoading) ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: (isLoading)
                ? AppColors.buttonTextDisabled
                : color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OperatorDetailLoadingState extends StatelessWidget {
  const OperatorDetailLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              "Loading report details…",
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class OperatorDetailErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const OperatorDetailErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 48),
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withOpacity(0.2)),
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
              "Failed to load report",
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
            const SizedBox(height: 20),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRetry,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Try Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
