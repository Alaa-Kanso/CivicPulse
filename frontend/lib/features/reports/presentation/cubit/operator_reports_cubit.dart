import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/report_type.dart';
import 'package:CivicPulse/features/reports/domain/useCases/get_category_types_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/operator_reports_use_case.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/operator_reports_state.dart';

class OperatorReportsCubit extends Cubit<OperatorReportsState> {
  OperatorReportsCubit({
    required this.getCategoryTypesUseCase,
    required this.operatorReportsUseCase,
  }) : super(OperatorReportsInitial());
  final GetCategoryTypesUseCase getCategoryTypesUseCase;
  final OperatorReportsUseCase operatorReportsUseCase;

  List<ReportType> categoryTypes = [];
  List<OperatorReport> reports = [];
  List<int> reportTypeFilter = [];
  List<String> statusFilter = [];
  String idFilter = "";

  Future<void> getReportsAndCategoryTypes() async {
    emit(OperatorReportsLoading());
    try {
      categoryTypes = await getCategoryTypesUseCase();
      reports = await operatorReportsUseCase();
      emit(
        OperatorReportsSuccess(
          reportTypes: categoryTypes,
          reports: reports,
          statusFilter: [],
          reportTypeFilter: [],
        ),
      );
    } catch (e) {
      emit(OperatorReportsError(error: e.toString()));
    }
  }

  void filterByStatus(String status) {
    final updatedStatusFilter = List<String>.from(statusFilter);

    if (updatedStatusFilter.contains(status)) {
      updatedStatusFilter.remove(status);
    } else {
      updatedStatusFilter.add(status);
    }

    statusFilter = updatedStatusFilter;

    applyFilter();
  }

  void filterByReportType(int id) {
    final updatedReportTypeFilter = List<int>.from(reportTypeFilter);

    if (updatedReportTypeFilter.contains(id)) {
      updatedReportTypeFilter.remove(id);
    } else {
      updatedReportTypeFilter.add(id);
    }

    reportTypeFilter = updatedReportTypeFilter;

    applyFilter();
  }

  void filterById(String id) {
    idFilter = id;
    applyFilter();
  }

  void applyFilter() {
    final filteredReports = reports
        .where(
          (element) =>
              (statusFilter.isEmpty || statusFilter.contains(element.status)) &&
              (reportTypeFilter.isEmpty ||
                  reportTypeFilter.contains(element.reportTypeId)) &&
              (idFilter.isEmpty || element.id.contains(idFilter)),
        )
        .toList();
    emit(
      (state as OperatorReportsSuccess).copyWith(
        statusFilter: statusFilter,
        reports: filteredReports,
        reportTypeFilter: reportTypeFilter,
      ),
    );
  }
}
