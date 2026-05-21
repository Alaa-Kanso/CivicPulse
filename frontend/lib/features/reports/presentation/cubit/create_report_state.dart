import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:frontend/features/reports/data/models/report_type_model.dart';

abstract class CreateReportState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateReportInitial extends CreateReportState {}

class CreateReportLoading extends CreateReportState {}

class CreateReportFailure extends CreateReportState {
  final String error;

  CreateReportFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class CreateReportSuccess extends CreateReportState {}

class CategoryTypesLoaded extends CreateReportState {
  final List<ReportTypeModel> reportCategoryTypes;

  CategoryTypesLoaded({required this.reportCategoryTypes});

  @override
  List<Object?> get props => [reportCategoryTypes];
}

class CategoryTypesError extends CreateReportState {
  final String error;

  CategoryTypesError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ChooseCategorySuccess extends CreateReportState {
  final ReportTypeModel reportTypeModel;

  ChooseCategorySuccess({required this.reportTypeModel});

  @override
  List<Object?> get props => [reportTypeModel];
}

class MarkLocationSuccess extends CreateReportState {
  final double latitude;
  final double longitude;
  final String placement;

  MarkLocationSuccess({
    required this.latitude,
    required this.longitude,
    required this.placement,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [latitude, longitude, placement];
}

class PickImageSuccess extends CreateReportState {
  final File? file;

  PickImageSuccess({required this.file});

  @override
  // TODO: implement props
  List<Object?> get props => [file];
}

class SubmitReportLoading extends CreateReportState {}
