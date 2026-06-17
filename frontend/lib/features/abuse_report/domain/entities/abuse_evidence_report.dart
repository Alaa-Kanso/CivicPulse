class AbuseEvidenceReport {
  final String id;
  final String reportTypeName;
  final String status;
  final bool isSpam;
  final String? spamReason;
  final String? municipalityName;
  final String? description;
  final DateTime createdAtUtc;

  AbuseEvidenceReport({
    required this.id,
    required this.reportTypeName,
    required this.status,
    required this.isSpam,
    required this.spamReason,
    required this.municipalityName,
    required this.description,
    required this.createdAtUtc,
  });
}
