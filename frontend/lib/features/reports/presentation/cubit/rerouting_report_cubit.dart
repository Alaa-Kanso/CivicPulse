import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:frontend/features/reports/domain/useCases/geocoding_location_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/get_admin_rerouting_reports_use_case.dart';
import 'package:frontend/features/reports/presentation/cubit/rerouting_report_state.dart';

class ReroutingReportCubit extends Cubit<ReroutingReportState> {
  ReroutingReportCubit({
    required this.getAdminReroutingReportsUseCase,
    required this.geocodingLocationUseCase,
  }) : super(ReroutingReportInitial());

  final GetAdminReroutingReportsUseCase getAdminReroutingReportsUseCase;
  final GeocodingLocationUseCase geocodingLocationUseCase;
  List<AdminRerouteReport> rerouteReports = [];

  Future<void> getAdminReroutingReports() async {
    emit(ReroutingReportLoading());
    try {
      rerouteReports = await getAdminReroutingReportsUseCase();
      emit(ReroutingReportSuccess(rerouteReports: rerouteReports));
    } catch (e) {
      emit(ReroutingReportFailure(error: e.toString()));
    }
  }

  Future<void> deleteReport({required String reportId}) async {}
}
