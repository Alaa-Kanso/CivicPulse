class ReportDetails {
  final String id;
  final String reportTypeName;
  final int reportTypeId;
  final String imageKey;
  final String? imageUrl;
  final String description;
  final String? addressDetails;
  final String status;
  final DateTime createdAtUtc;
  final String location;

  ReportDetails({
    required this.id,
    required this.reportTypeName,
    required this.imageKey,
    required this.description,
    required this.addressDetails,
    required this.status,
    required this.createdAtUtc,
    required this.location,
    required this.reportTypeId,
    required this.imageUrl,
  });
}
