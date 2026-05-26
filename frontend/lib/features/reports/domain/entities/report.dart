class Report {
  final String id;
  final int reportTypeId;
  final String reportTypeName;
  final int? municipalityId;
  final String? municipalityName;

  final String imageKey;
  final String? imageUrl;
  final String description;
  final String? addressDetails;

  final String status;
  final DateTime createdAtUtc;

  final double latitude;
  final double longitude;

  Report({
    required this.id,
    required this.reportTypeId,
    required this.reportTypeName,
    required this.municipalityId,
    required this.municipalityName,
    required this.imageKey,
    required this.description,
    required this.addressDetails,
    required this.status,
    required this.createdAtUtc,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });
}
