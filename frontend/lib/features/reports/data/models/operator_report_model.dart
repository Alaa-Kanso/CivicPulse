import 'package:frontend/features/reports/domain/entities/operator_report.dart';

class OperatorReportModel extends OperatorReport {
  OperatorReportModel({
    required super.id,
    required super.reportTypeId,
    required super.reportTypeName,
    required super.municipalityId,
    required super.municipalityName,
    required super.status,
    required super.createdAtUtc,
    required super.addressDetails,
    required super.description,
    required super.isSpam,
    required super.reportedUserUnderReview,
    required super.reportedUserIsRestricted,
    required super.hasPendingManualEscalation,
    required super.hasPendingTooManySpamCase,
  });

  factory OperatorReportModel.fromJson(Map<String, dynamic> json) {
    return OperatorReportModel(
      id: json['id'] as String,

      reportTypeId: json['reportTypeId'] as int,
      reportTypeName: json['reportTypeName'] as String,

      municipalityId: json['municipalityId'] as int,
      municipalityName: json['municipalityName'] as String,

      status: json['status'] as String,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),

      addressDetails: json['addressDetails'] as String?,
      description: json['description'] as String,

      isSpam: json['isSpam'] as bool,

      reportedUserUnderReview: json['reportedUserUnderReview'] as bool,
      reportedUserIsRestricted: json['reportedUserIsRestricted'] as bool,
      hasPendingManualEscalation: json['hasPendingManualEscalation'] as bool,
      hasPendingTooManySpamCase: json['hasPendingTooManySpamCase'] as bool,
    );
  }
}
