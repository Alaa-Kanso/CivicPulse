import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_evidence_report.dart';

class AbuseEvidenceReportModel extends AbuseEvidenceReport {
  AbuseEvidenceReportModel({
    required super.id,
    required super.reportTypeName,
    required super.status,
    required super.isSpam,
    required super.spamReason,
    required super.municipalityName,
    required super.description,
    required super.createdAtUtc,
  });

  factory AbuseEvidenceReportModel.fromJson(Map<String, dynamic> json) {
    return AbuseEvidenceReportModel(
      id: json['id'],
      reportTypeName: json['reportTypeName'],
      status: json['status'],
      isSpam: json['isSpam'],
      spamReason: json['spamReason'],
      municipalityName: json['municipalityName'],
      description: json['description'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
    );
  }
}
