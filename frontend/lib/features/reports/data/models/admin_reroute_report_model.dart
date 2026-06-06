import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';

class AdminRerouteReportModel extends AdminRerouteReport {
  AdminRerouteReportModel({
    required super.id,
    required super.reportTypeId,
    required super.reportTypeName,
    required super.municipalityId,
    required super.municipalityName,
    required super.originalMunicipalityName,
    required super.adminRoutingReason,
    required super.imageKey,
    required super.description,
    required super.addressDetails,
    required super.latitude,
    required super.longitude,
    required super.createdAtUtc,
  });

  factory AdminRerouteReportModel.fromJson(Map<String, dynamic> json) {
    return AdminRerouteReportModel(
      id: json['id'] as String,

      reportTypeId: json['reportTypeId'] as int,
      reportTypeName: json['reportTypeName'] as String,

      municipalityId: json['municipalityId'] as int?,
      municipalityName: json['municipalityName'] as String?,
      originalMunicipalityName: json['originalMunicipalityName'] as String?,

      adminRoutingReason: json['adminRoutingReason'] as String,

      imageKey: json['imageKey'] as String,
      description: json['description'] as String,
      addressDetails: json['addressDetails'] as String?,

      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),

      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'reportTypeId': reportTypeId,
      'reportTypeName': reportTypeName,

      'municipalityId': municipalityId,
      'municipalityName': municipalityName,
      'originalMunicipalityName': originalMunicipalityName,

      'adminRoutingReason': adminRoutingReason,

      'imageKey': imageKey,
      'description': description,
      'addressDetails': addressDetails,

      'latitude': latitude,
      'longitude': longitude,

      'createdAtUtc': createdAtUtc.toUtc().toIso8601String(),
    };
  }
}
