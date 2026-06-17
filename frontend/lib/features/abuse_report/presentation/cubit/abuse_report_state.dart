import 'package:equatable/equatable.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';

abstract class AbuseReportState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AbuseReportInitial extends AbuseReportState {}

class AbuseReportLoading extends AbuseReportState {}

class AbuseReportError extends AbuseReportState {
  final String error;

  AbuseReportError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class AbuseReportSuccess extends AbuseReportState {
  final List<AbuseReport> abuseReports;

  AbuseReportSuccess({required this.abuseReports});

  @override
  // TODO: implement props
  List<Object?> get props => [abuseReports];
}
