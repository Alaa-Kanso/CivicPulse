import 'package:flutter/material.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';

// ── Abuse Report Summary Card ──
class AbuseReportCard extends StatelessWidget {
  final AbuseReport report;
  final VoidCallback? onViewDetails;

  const AbuseReportCard({
    super.key,
    required this.report,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final relativeTime = _formatTimeAgo(report.createdAtUtc);

    Color severityColor = AppColors.info;
    Color severityBg = AppColors.info.withValues(alpha: 0.1);
    if (report.reportedUserSpamStrikes >= 3) {
      severityColor = AppColors.error;
      severityBg = AppColors.error.withValues(alpha: 0.1);
    } else if (report.reportedUserSpamStrikes > 0) {
      severityColor = AppColors.warning;
      severityBg = AppColors.warning.withValues(alpha: 0.1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Severity indicator bar
              Container(width: 6, color: severityColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: email + status chip
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              report.reportedUserEmail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(report.moderationStatus),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Report type label
                      Text(
                        report.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: severityColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Reason summary
                      Text(
                        report.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Meta row: strikes + time + View Details
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: severityBg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${report.reportedUserSpamStrikes} '
                              'Strike${report.reportedUserSpamStrikes == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: severityColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            relativeTime,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: onViewDetails,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 15,
                            ),
                            label: const Text('View Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = AppColors.warning.withValues(alpha: 0.1);
        fg = AppColors.warning;
        icon = Icons.pending_actions_rounded;
        break;
      case 'reviewed':
      case 'resolved':
        bg = AppColors.success.withValues(alpha: 0.1);
        fg = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'dismissed':
        bg = AppColors.surface;
        fg = AppColors.textSecondary;
        icon = Icons.cancel_outlined;
        break;
      default:
        bg = AppColors.info.withValues(alpha: 0.1);
        fg = AppColors.info;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Relative Time Helper ──
String _formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now().toUtc();
  final diff = now.difference(dateTime.toUtc());

  if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
  if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
  if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
  if (diff.inDays > 0) return '${diff.inDays}d ago';
  if (diff.inHours > 0) return '${diff.inHours}h ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
  return 'Just now';
}
