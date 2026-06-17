import 'package:flutter/material.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_evidence_report.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report_details.dart';

// ── Status Badge Helper ──
class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  const StatusBadge({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'pending':
        bg = AppColors.warning.withValues(alpha: 0.12);
        fg = AppColors.warning;
        icon = Icons.pending_actions_rounded;
        break;
      case 'reviewed':
      case 'resolved':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'dismissed':
        bg = AppColors.surface;
        fg = AppColors.textSecondary;
        icon = Icons.cancel_outlined;
        break;
      case 'blocked':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        icon = Icons.block_rounded;
        break;
      case 'active':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        icon = Icons.check_circle_outline_rounded;
        break;
      default:
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        icon = Icons.info_outline;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 1, color: fg),
          const SizedBox(width: 5),
          Text(
            status.toUpperCase(),
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

// ── Section Card Wrapper ──
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final Widget? trailing;
  const SectionCard({super.key, required this.title, required this.icon, this.iconColor, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.5)),
          Padding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 16), child: child),
        ],
      ),
    );
  }
}

// ── Info Row ──
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  final bool mono;
  const InfoRow({super.key, required this.label, this.value = '', this.valueWidget, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: mono ? 'monospace' : null,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Abuse Case Summary Section ──
class AbuseCaseSummarySection extends StatelessWidget {
  final AbuseReportDetails details;
  const AbuseCaseSummarySection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Abuse Case Summary',
      icon: Icons.gavel_rounded,
      trailing: StatusBadge(status: details.moderationStatus),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: 'Case ID', value: details.id, mono: true),
          InfoRow(label: 'Type', valueWidget: _typeBadge(details.type)),
          InfoRow(label: 'Reason', value: details.reason),
          InfoRow(label: 'Created', value: _fmtDate(details.createdAtUtc)),
          if (details.reviewedAtUtc != null) InfoRow(label: 'Reviewed', value: _fmtDate(details.reviewedAtUtc!)),
          const SizedBox(height: 6),
          _notesBlock(details.adminNotes),
        ],
      ),
    );
  }

  Widget _typeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(type.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
    );
  }

  Widget _notesBlock(String? notes) {
    if (notes == null || notes.trim().isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(Icons.notes_rounded, size: 16, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(width: 8),
            Text('No admin notes recorded', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary.withValues(alpha: 0.7), fontStyle: FontStyle.italic)),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.info.withValues(alpha: 0.15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.notes_rounded, size: 14, color: AppColors.info),
            const SizedBox(width: 6),
            const Text('Admin Notes', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.info)),
          ]),
          const SizedBox(height: 6),
          Text(notes, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
        ],
      ),
    );
  }
}

// ── Reported User Section ──
class ReportedUserSection extends StatelessWidget {
  final AbuseReportDetails details;
  const ReportedUserSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final strikes = details.reportedUserSpamStrikes;
    Color severityColor = AppColors.info;
    if (strikes >= 3) {
      severityColor = AppColors.error;
    } else if (strikes > 0) {
      severityColor = AppColors.warning;
    }

    return SectionCard(
      title: 'Reported User',
      icon: Icons.person_off_rounded,
      iconColor: AppColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: severityColor.withValues(alpha: 0.12),
                child: Icon(Icons.person_rounded, size: 24, color: severityColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(details.reportedUserEmail, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatusBadge(status: details.reportedUserStatus, fontSize: 10),
                        const SizedBox(width: 8),
                        _strikeBadge(strikes, severityColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InfoRow(label: 'User ID', value: details.reportedUserId, mono: true),
        ],
      ),
    );
  }

  Widget _strikeBadge(int strikes, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text('$strikes Strike${strikes == 1 ? '' : 's'}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

// ── Reporting Operator Section ──
class ReportingOperatorSection extends StatelessWidget {
  final AbuseReportDetails details;
  const ReportingOperatorSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Reporting Operator',
      icon: Icons.support_agent_rounded,
      iconColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: 'Operator Email', value: details.reportedByOperatorEmail),
          InfoRow(label: 'Operator ID', value: details.reportedByOperatorId, mono: true),
        ],
      ),
    );
  }
}

// ── Trigger Report Section ──
class TriggerReportSection extends StatelessWidget {
  final AbuseEvidenceReport report;
  const TriggerReportSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Trigger Report',
      icon: Icons.flag_rounded,
      iconColor: AppColors.warning,
      trailing: report.isSpam ? _spamTag() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: 'Report ID', value: report.id, mono: true),
          InfoRow(label: 'Type', value: report.reportTypeName),
          InfoRow(label: 'Status', valueWidget: StatusBadge(status: report.status, fontSize: 10)),
          InfoRow(label: 'Municipality', value: report.municipalityName ?? 'N/A'),
          InfoRow(label: 'Created', value: _fmtDate(report.createdAtUtc)),
          if (report.description != null && report.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
              child: Text(report.description!, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
            ),
          ],
          if (report.isSpam && report.spamReason != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.error.withValues(alpha: 0.15))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.report_problem_rounded, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Spam Reason: ${report.spamReason}', style: TextStyle(fontSize: 12, color: AppColors.error, height: 1.4))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _spamTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.report_rounded, size: 12, color: AppColors.error),
          const SizedBox(width: 4),
          Text('SPAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.error, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ── Evidence Reports Section ──
class EvidenceReportsSection extends StatelessWidget {
  final List<AbuseEvidenceReport> reports;
  const EvidenceReportsSection({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Evidence Reports',
      icon: Icons.folder_copy_rounded,
      iconColor: AppColors.primaryLight,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Text('${reports.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ),
      child: reports.isEmpty ? _emptyEvidence() : _evidenceList(),
    );
  }

  Widget _emptyEvidence() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(Icons.folder_off_rounded, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.35)),
          const SizedBox(height: 10),
          const Text('No evidence reports', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('No supporting reports are linked to this case.', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _evidenceList() {
    return Column(
      children: List.generate(reports.length, (i) {
        final r = reports[i];
        return Container(
          margin: EdgeInsets.only(bottom: i < reports.length - 1 ? 10 : 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(r.reportTypeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ),
                  StatusBadge(status: r.status, fontSize: 9),
                  if (r.isSpam) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('SPAM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.error)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_city_rounded, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(r.municipalityName ?? 'N/A', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(_fmtDate(r.createdAtUtc), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              if (r.description != null && r.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(r.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4)),
              ],
              if (r.isSpam && r.spamReason != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.report_problem_rounded, size: 12, color: AppColors.error),
                    const SizedBox(width: 4),
                    Expanded(child: Text(r.spamReason!, style: TextStyle(fontSize: 11.5, color: AppColors.error))),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

// ── Moderation Actions Section ──
class ModerationActionsSection extends StatelessWidget {
  final String reportId;
  final bool isLoading;
  final VoidCallback onBlockUser;
  final VoidCallback onDismiss;
  const ModerationActionsSection({super.key, required this.reportId, required this.isLoading, required this.onBlockUser, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Moderation Actions',
      icon: Icons.admin_panel_settings_rounded,
      iconColor: AppColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Take a moderation decision on this abuse report. These actions are irreversible.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Block User',
                  icon: Icons.block_rounded,
                  color: AppColors.error,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _confirmAction(context, 'Block User', 'Are you sure you want to block this user? This action cannot be undone.', onBlockUser),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Dismiss Report',
                  icon: Icons.cancel_outlined,
                  color: AppColors.textSecondary,
                  outlined: true,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _confirmAction(context, 'Dismiss Report', 'Are you sure you want to dismiss this abuse report?', onDismiss),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmAction(BuildContext context, String title, String message, VoidCallback action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content: Text(message, style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Navigator.of(ctx).pop(); action(); },
            style: ElevatedButton.styleFrom(backgroundColor: title.contains('Block') ? AppColors.error : AppColors.primary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool outlined;
  final bool isLoading;
  final VoidCallback? onPressed;
  const _ActionButton({required this.label, required this.icon, required this.color, this.outlined = false, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: isLoading ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color)) : Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Loading Shimmer Section ──
class DetailsLoadingShimmer extends StatelessWidget {
  const DetailsLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(4, (i) => Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
          ),
          child: Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary.withValues(alpha: 0.3)))),
        )),
      ),
    );
  }
}

// ── Error State ──
class DetailsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const DetailsErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 44, color: AppColors.error),
            const SizedBox(height: 14),
            const Text('Failed to load report', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.error)),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date Formatter ──
String _fmtDate(DateTime dt) {
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final d = dt.toLocal();
  final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
  final ampm = d.hour >= 12 ? 'PM' : 'AM';
  return '${months[d.month - 1]} ${d.day}, ${d.year} · ${h.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} $ampm';
}
