import 'package:CivicPulse/features/reports/domain/entities/operator_report_details.dart';

class OperatorReportDetailsModel extends OperatorReportDetails {
  OperatorReportDetailsModel({
    required super.id,
    required super.reportTypeId,
    required super.reportTypeName,
    required super.municipalityId,
    required super.municipalityName,
    required super.imageKey,
    required super.imageUrl,
    required super.description,
    required super.addressDetails,
    required super.status,
    required super.createdAtUtc,
    required super.updatedAtUtc,
    required super.latitude,
    required super.longitude,
    required super.isSpam,
    required super.spamReason,
    required super.spamMarkedAtUtc,
    required super.reportedUserUnderReview,
    required super.reportedUserIsRestricted,
    required super.hasPendingManualEscalation,
    required super.hasPendingTooManySpamCase,
  });

  factory OperatorReportDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperatorReportDetailsModel(
      id: json['id'],
      reportTypeId: json['reportTypeId'],
      reportTypeName: json['reportTypeName'],
      municipalityId: json['municipalityId'],
      municipalityName: json['municipalityName'],

      imageKey: json['imageKey'],
      imageUrl: json['imageUrl'],

      description: json['description'],
      addressDetails: json['addressDetails'],
      status: json['status'],

      createdAtUtc: DateTime.parse(json['createdAtUtc']),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc']),

      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),

      isSpam: json['isSpam'],

      spamReason: json['spamReason'],
      spamMarkedAtUtc: json['spamMarkedAtUtc'] != null
          ? DateTime.parse(json['spamMarkedAtUtc'])
          : null,

      reportedUserUnderReview: json['reportedUserUnderReview'],
      reportedUserIsRestricted: json['reportedUserIsRestricted'],

      hasPendingManualEscalation: json['hasPendingManualEscalation'],
      hasPendingTooManySpamCase: json['hasPendingTooManySpamCase'],
    );
  }
}
