class OperatorReportDetails {
  final String id;
  final int reportTypeId;
  final String reportTypeName;
  final int municipalityId;
  final String municipalityName;

  final String? imageKey;
  final String? imageUrl;

  final String description;
  final String addressDetails;
  final String status;

  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  final double latitude;
  final double longitude;

  final bool isSpam;
  final String? spamReason;
  final DateTime? spamMarkedAtUtc;

  final bool reportedUserUnderReview;
  final bool reportedUserIsRestricted;

  final bool hasPendingManualEscalation;
  final bool hasPendingTooManySpamCase;

  OperatorReportDetails({
    required this.id,
    required this.reportTypeId,
    required this.reportTypeName,
    required this.municipalityId,
    required this.municipalityName,
    required this.imageKey,
    required this.imageUrl,
    required this.description,
    required this.addressDetails,
    required this.status,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.latitude,
    required this.longitude,
    required this.isSpam,
    required this.spamReason,
    required this.spamMarkedAtUtc,
    required this.reportedUserUnderReview,
    required this.reportedUserIsRestricted,
    required this.hasPendingManualEscalation,
    required this.hasPendingTooManySpamCase,
  });
}
