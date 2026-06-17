class AbuseReport {
  final String id;

  final String type;
  final String reason;
  final String moderationStatus;
  final DateTime createdAtUtc;

  final String reportedUserId;
  final String reportedUserEmail;
  final String reportedUserStatus;
  final int reportedUserSpamStrikes;

  final String reportedByOperatorId;
  final String reportedByOperatorEmail;

  final String triggerReportId;
  final String triggerReportStatus;
  final String? triggerMunicipalityName;

  final int evidenceReportsCount;

  AbuseReport({
    required this.id,
    required this.type,
    required this.reason,
    required this.moderationStatus,
    required this.createdAtUtc,
    required this.reportedUserId,
    required this.reportedUserEmail,
    required this.reportedUserStatus,
    required this.reportedUserSpamStrikes,
    required this.reportedByOperatorId,
    required this.reportedByOperatorEmail,
    required this.triggerReportId,
    required this.triggerReportStatus,
    required this.triggerMunicipalityName,
    required this.evidenceReportsCount,
  });
}
