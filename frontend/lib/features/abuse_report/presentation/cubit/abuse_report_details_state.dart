import 'package:equatable/equatable.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report_details.dart';

abstract class AbuseReportDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbuseReportDetailsInitial extends AbuseReportDetailsState {}

class AbuseReportDetailsLoading extends AbuseReportDetailsState {}

class AbuseReportDetailsError extends AbuseReportDetailsState {
  final String error;

  AbuseReportDetailsError({required this.error});

  @override
  List<Object?> get props => [error];
}

class AbuseReportDetailsSuccess extends AbuseReportDetailsState {
  final AbuseReportDetails reportDetails;

  AbuseReportDetailsSuccess({required this.reportDetails});

  @override
  List<Object?> get props => [reportDetails];
}
