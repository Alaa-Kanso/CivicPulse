import 'package:equatable/equatable.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report_details.dart';

abstract class OperatorReportDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OperatorReportDetailsInitial extends OperatorReportDetailsState {}

class OperatorReportDetailsLoading extends OperatorReportDetailsState {}

class OperatorReportDetailsError extends OperatorReportDetailsState {
  final String error;

  OperatorReportDetailsError({required this.error});

  @override
  List<Object?> get props => [error];
}

class OperatorReportDetailsSuccess extends OperatorReportDetailsState {
  final OperatorReportDetails reportDetails;

  OperatorReportDetailsSuccess({required this.reportDetails});

  @override
  List<Object?> get props => [reportDetails];
}
