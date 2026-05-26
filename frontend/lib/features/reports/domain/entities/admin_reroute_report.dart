class AdminRerouteReport {
  final String id;

  final int reportTypeId;
  final String reportTypeName;

  final int? municipalityId;
  final String? municipalityName;
  final String? originalMunicipalityName;

  final String adminRoutingReason;

  final String imageKey;
  final String description;
  final String? addressDetails;

  final double latitude;
  final double longitude;

  final DateTime createdAtUtc;

  AdminRerouteReport({
    required this.id,
    required this.reportTypeId,
    required this.reportTypeName,
    required this.municipalityId,
    required this.municipalityName,
    required this.originalMunicipalityName,
    required this.adminRoutingReason,
    required this.imageKey,
    required this.description,
    required this.addressDetails,
    required this.latitude,
    required this.longitude,
    required this.createdAtUtc,
  });
}
