import 'package:frontend/features/abuse_report/domain/entities/abuse_evidence_report.dart';

class AbuseReportDetails {
  final String id;
  final String type;
  final String reason;
  final String moderationStatus;
  final DateTime createdAtUtc;
  final DateTime? reviewedAtUtc;
  final String? adminNotes;

  final String reportedUserId;
  final String reportedUserEmail;
  final String reportedUserStatus;
  final int reportedUserSpamStrikes;

  final String reportedByOperatorId;
  final String reportedByOperatorEmail;

  final String triggerReportId;
  final AbuseEvidenceReport triggerReport;

  final List<AbuseEvidenceReport> evidenceReports;

  AbuseReportDetails({
    required this.id,
    required this.type,
    required this.reason,
    required this.moderationStatus,
    required this.createdAtUtc,
    required this.reviewedAtUtc,
    required this.adminNotes,
    required this.reportedUserId,
    required this.reportedUserEmail,
    required this.reportedUserStatus,
    required this.reportedUserSpamStrikes,
    required this.reportedByOperatorId,
    required this.reportedByOperatorEmail,
    required this.triggerReportId,
    required this.triggerReport,
    required this.evidenceReports,
  });
}
