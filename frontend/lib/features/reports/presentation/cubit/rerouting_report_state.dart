import 'package:equatable/equatable.dart';

abstract class ReroutingReportState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReroutingReportInitial extends ReroutingReportState {}

class ReroutingReportLoading extends ReroutingReportState {}

class ReroutingReportFailure extends ReroutingReportState {
  final String error;

  ReroutingReportFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ReroutingReportSuccess extends ReroutingReportState {}
