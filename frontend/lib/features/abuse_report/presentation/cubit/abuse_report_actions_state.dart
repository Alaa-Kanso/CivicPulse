import 'package:equatable/equatable.dart';

abstract class AbuseReportActionsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AbuseReportActionsInitial extends AbuseReportActionsState {}

class AbuseReportActionsLoading extends AbuseReportActionsState {}

class AbuseReportActionsFailure extends AbuseReportActionsState {
  final String error;

  AbuseReportActionsFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class AbuseReportActionsSuccess extends AbuseReportActionsState {
  final String message;

  AbuseReportActionsSuccess({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
