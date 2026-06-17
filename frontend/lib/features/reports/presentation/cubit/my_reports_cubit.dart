import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/reports/data/models/report_type_model.dart';
import 'package:CivicPulse/features/reports/domain/entities/report_details.dart';
import 'package:CivicPulse/features/reports/domain/useCases/geocoding_location_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/get_category_types_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/get_my_reports_use_case.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/my_reports_state.dart';

class MyReportsCubit extends Cubit<MyReportsState> {
  MyReportsCubit({
    required this.getMyReportsUseCase,
    required this.geocodingLocationUseCase,
    required this.getCategoryTypesUseCase,
  }) : super(MyReportsInitial());

  final GetMyReportsUseCase getMyReportsUseCase;
  final GeocodingLocationUseCase geocodingLocationUseCase;
  final GetCategoryTypesUseCase getCategoryTypesUseCase;

  List<ReportDetails> _allReports = [];
  List<int> categoryFilter = [];
  List<String> statusFilter = [];
  List<ReportTypeModel> reportType = [];

  Future<void> getMyReports() async {
    try {
      emit(MyReportsLoading());
      final myReports = await getMyReportsUseCase.call();
      reportType = await getCategoryTypesUseCase.call();
      final reportDetails = await Future.wait(
        myReports.map(
          (e) async => ReportDetails(
            id: e.id,
            reportTypeName: e.reportTypeName,
            imageKey: e.imageKey,
            description: e.description,
            addressDetails: e.addressDetails,
            status: e.status,
            createdAtUtc: e.createdAtUtc,
            location: await geocodingLocationUseCase.call(
              latitude: e.latitude,
              longitude: e.longitude,
            ),
            reportTypeId: e.reportTypeId,
            imageUrl: e.imageUrl ?? "",
          ),
        ),
      );
      _allReports = reportDetails;
      emit(
        MyReportsSuccess(
          myReports: _allReports,
          categoryFilter: [],
          statusFilter: [],
          reportTypes: reportType,
        ),
      );
    } catch (e) {
      emit(MyReportsError(error: e.toString()));
    }
  }

  void addOrRemoveCategoryFilter(int value) {
    final updated = List<int>.from(categoryFilter);

    if (updated.contains(value)) {
      updated.remove(value);
    } else {
      updated.add(value);
    }
    categoryFilter = updated;
    emit((state as MyReportsSuccess).copyWith(categoryFilter: categoryFilter));
  }

  void addOrRemoveStatusFilter(String value) {
    final updated = List<String>.from(statusFilter);

    if (updated.contains(value)) {
      updated.remove(value);
    } else {
      updated.add(value);
    }

    statusFilter = updated;
    emit((state as MyReportsSuccess).copyWith(statusFilter: statusFilter));
  }

  void applyFilter() {
    List<ReportDetails> filteredReports = _allReports
        .where(
          (e) =>
              (categoryFilter.isEmpty ||
                  categoryFilter.contains(e.reportTypeId)) &&
              (statusFilter.isEmpty || statusFilter.contains(e.status)),
        )
        .toList();

    emit((state as MyReportsSuccess).copyWith(myReports: filteredReports));
  }

  void clearFilters() {
    statusFilter = [];
    categoryFilter = [];

    emit(
      (state as MyReportsSuccess).copyWith(
        statusFilter: statusFilter,
        categoryFilter: categoryFilter,
        myReports: _allReports,
      ),
    );
  }
}
