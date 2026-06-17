class OperatorReport {
  final String id;

  final int reportTypeId;
  final String reportTypeName;

  final int municipalityId;
  final String municipalityName;

  final String status;
  final DateTime createdAtUtc;

  final String? addressDetails;
  final String description;

  final bool isSpam;

  final bool reportedUserUnderReview;
  final bool reportedUserIsRestricted;
  final bool hasPendingManualEscalation;
  final bool hasPendingTooManySpamCase;

  OperatorReport({
    required this.id,
    required this.reportTypeId,
    required this.reportTypeName,
    required this.municipalityId,
    required this.municipalityName,
    required this.status,
    required this.createdAtUtc,
    required this.addressDetails,
    required this.description,
    required this.isSpam,
    required this.reportedUserUnderReview,
    required this.reportedUserIsRestricted,
    required this.hasPendingManualEscalation,
    required this.hasPendingTooManySpamCase,
  });
}
