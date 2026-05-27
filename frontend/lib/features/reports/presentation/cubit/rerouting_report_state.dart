import 'package:equatable/equatable.dart';
import 'package:frontend/features/reports/domain/entities/admin_reroute_report.dart';

abstract class ReroutingReportState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReroutingReportInitial extends ReroutingReportState {}

class ReroutingReportLoading extends ReroutingReportState {}

class ActionReroutingReportLoading extends ReroutingReportState {}

class ReroutingReportFailure extends ReroutingReportState {
  final String error;

  ReroutingReportFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ActionReroutingReportFailure extends ReroutingReportState {
  final String error;

  ActionReroutingReportFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ReroutingReportSuccess extends ReroutingReportState {
  final List<AdminRerouteReport> rerouteReports;

  ReroutingReportSuccess({required this.rerouteReports});

  @override
  List<Object?> get props => [rerouteReports];
}

class ActionReroutingReportSuccess extends ReroutingReportState {}
