import 'package:CivicPulse/features/reports/domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel({
    required super.id,
    required super.reportTypeId,
    required super.reportTypeName,
    required super.municipalityId,
    required super.municipalityName,
    required super.imageKey,
    required super.description,
    required super.addressDetails,
    required super.status,
    required super.createdAtUtc,
    required super.latitude,
    required super.longitude,
    required super.imageUrl,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      reportTypeId: json['reportTypeId'],
      reportTypeName: json['reportTypeName'],
      municipalityId: json['municipalityId'],
      municipalityName: json['municipalityName'],
      imageKey: json['imageKey'],
      description: json['description'],
      addressDetails: json['addressDetails'],
      status: json['status'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportTypeId': reportTypeId,
      'reportTypeName': reportTypeName,
      'municipalityId': municipalityId,
      'municipalityName': municipalityName,
      'imageKey': imageKey,
      'description': description,
      'addressDetails': addressDetails,
      'status': status,
      'createdAtUtc': createdAtUtc.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }
}
