import 'package:frontend/features/abuse_report/domain/entities/abuse_report.dart';

class AbuseReportModel extends AbuseReport {
  AbuseReportModel({
    required super.id,
    required super.type,
    required super.reason,
    required super.moderationStatus,
    required super.createdAtUtc,
    required super.reportedUserId,
    required super.reportedUserEmail,
    required super.reportedUserStatus,
    required super.reportedUserSpamStrikes,
    required super.reportedByOperatorId,
    required super.reportedByOperatorEmail,
    required super.triggerReportId,
    required super.triggerReportStatus,
    required super.triggerMunicipalityName,
    required super.evidenceReportsCount,
  });

  factory AbuseReportModel.fromJson(Map<String, dynamic> json) {
    return AbuseReportModel(
      id: json['id'],
      type: json['type'],
      reason: json['reason'],
      moderationStatus: json['moderationStatus'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),

      reportedUserId: json['reportedUserId'],
      reportedUserEmail: json['reportedUserEmail'],
      reportedUserStatus: json['reportedUserStatus'],
      reportedUserSpamStrikes: json['reportedUserSpamStrikes'],

      reportedByOperatorId: json['reportedByOperatorId'],
      reportedByOperatorEmail: json['reportedByOperatorEmail'],

      triggerReportId: json['triggerReportId'],
      triggerReportStatus: json['triggerReportStatus'],
      triggerMunicipalityName: json['triggerMunicipalityName'],

      evidenceReportsCount: json['evidenceReportsCount'],
    );
  }
}
