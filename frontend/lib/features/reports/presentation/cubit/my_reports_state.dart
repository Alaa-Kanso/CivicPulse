import 'package:equatable/equatable.dart';
import 'package:frontend/features/reports/data/models/report_type_model.dart';
import 'package:frontend/features/reports/domain/entities/report_details.dart';

abstract class MyReportsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MyReportsInitial extends MyReportsState {}

class MyReportsLoading extends MyReportsState {}

class MyReportsSuccess extends MyReportsState {
  final List<ReportDetails> myReports;
  final List<int> categoryFilter;
  final List<String> statusFilter;
  final List<ReportTypeModel> reportTypes;

  MyReportsSuccess({
    required this.myReports,
    required this.categoryFilter,
    required this.statusFilter,
    required this.reportTypes,
  });

  MyReportsSuccess copyWith({
    List<ReportDetails>? myReports,
    List<int>? categoryFilter,
    List<String>? statusFilter,
    List<ReportTypeModel>? reportTypes,
  }) {
    return MyReportsSuccess(
      myReports: myReports ?? List.from(this.myReports),
      categoryFilter: categoryFilter ?? List.from(this.categoryFilter),
      statusFilter: statusFilter ?? List.from(this.statusFilter),
      reportTypes: reportTypes ?? List.from(this.reportTypes),
    );
  }

  @override
  List<Object?> get props => [
    myReports,
    categoryFilter,
    statusFilter,
    reportTypes,
  ];
}

class MyReportsError extends MyReportsState {
  final String error;

  MyReportsError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
