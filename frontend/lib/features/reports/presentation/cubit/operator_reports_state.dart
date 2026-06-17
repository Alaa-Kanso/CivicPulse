import 'package:equatable/equatable.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/report_type.dart';

abstract class OperatorReportsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OperatorReportsInitial extends OperatorReportsState {}

class OperatorReportsLoading extends OperatorReportsState {}

class OperatorReportsError extends OperatorReportsState {
  final String error;

  OperatorReportsError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class OperatorReportsSuccess extends OperatorReportsState {
  final List<ReportType> reportTypes;
  final List<OperatorReport> reports;
  final List<String> statusFilter;
  final List<int> reportTypeFilter;

  OperatorReportsSuccess({
    required this.reportTypes,
    required this.reports,
    required this.statusFilter,
    required this.reportTypeFilter,
  });

  OperatorReportsSuccess copyWith({
    List<ReportType>? reportTypes,
    List<OperatorReport>? reports,
    final List<String>? statusFilter,
    final List<int>? reportTypeFilter,
  }) {
    return OperatorReportsSuccess(
      reportTypes: reportTypes ?? this.reportTypes,
      reports: reports ?? this.reports,
      statusFilter: statusFilter ?? this.statusFilter,
      reportTypeFilter: reportTypeFilter ?? this.reportTypeFilter,
    );
  }

  @override
  List<Object?> get props => [
    reportTypes,
    reports,
    statusFilter,
    reportTypeFilter,
  ];
}
