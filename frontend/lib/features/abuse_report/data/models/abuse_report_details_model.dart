import 'package:frontend/features/abuse_report/data/models/abuse_evidence_report_model.dart';
import 'package:frontend/features/abuse_report/domain/entities/abuse_report_details.dart';

class AbuseReportDetailsModel extends AbuseReportDetails {
  AbuseReportDetailsModel({
    required super.id,
    required super.type,
    required super.reason,
    required super.moderationStatus,
    required super.createdAtUtc,
    required super.reviewedAtUtc,
    required super.adminNotes,
    required super.reportedUserId,
    required super.reportedUserEmail,
    required super.reportedUserStatus,
    required super.reportedUserSpamStrikes,
    required super.reportedByOperatorId,
    required super.reportedByOperatorEmail,
    required super.triggerReportId,
    required super.triggerReport,
    required super.evidenceReports,
  });

  factory AbuseReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return AbuseReportDetailsModel(
      id: json['id'],
      type: json['type'],
      reason: json['reason'],
      moderationStatus: json['moderationStatus'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
      reviewedAtUtc: json['reviewedAtUtc'] != null
          ? DateTime.parse(json['reviewedAtUtc'])
          : null,
      adminNotes: json['adminNotes'],

      reportedUserId: json['reportedUserId'],
      reportedUserEmail: json['reportedUserEmail'],
      reportedUserStatus: json['reportedUserStatus'],
      reportedUserSpamStrikes: json['reportedUserSpamStrikes'],

      reportedByOperatorId: json['reportedByOperatorId'],
      reportedByOperatorEmail: json['reportedByOperatorEmail'],

      triggerReportId: json['triggerReportId'],
      triggerReport: AbuseEvidenceReportModel.fromJson(json['triggerReport']),

      evidenceReports: (json['evidenceReports'] as List)
          .map(
            (e) => AbuseEvidenceReportModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
