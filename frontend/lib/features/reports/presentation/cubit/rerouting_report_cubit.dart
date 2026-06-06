import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:CivicPulse/features/reports/domain/useCases/delete_report_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/get_admin_rerouting_reports_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/reroute_municipality_use_case.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/rerouting_report_state.dart';

class ReroutingReportCubit extends Cubit<ReroutingReportState> {
  ReroutingReportCubit({
    required this.getAdminReroutingReportsUseCase,
    required this.deleteReportUseCase,
    required this.rerouteMunicipalityUseCase,
  }) : super(ReroutingReportInitial());

  final GetAdminReroutingReportsUseCase getAdminReroutingReportsUseCase;
  final DeleteReportUseCase deleteReportUseCase;
  final RerouteMunicipalityUseCase rerouteMunicipalityUseCase;
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

  Future<void> deleteReport({required String reportId}) async {
    emit(ActionReroutingReportLoading());
    try {
      await deleteReportUseCase(reportId: reportId);
      emit(ActionReroutingReportSuccess());
    } catch (e) {
      emit(ActionReroutingReportFailure(error: e.toString()));
    }
  }

  Future<void> rerouteReport({
    required String reportId,
    required int? municipalityId,
  }) async {
    if (municipalityId == null || reportId.isEmpty) {
      emit(ActionReroutingReportFailure(error: "assign a municipality"));
      return;
    }
    emit(ActionReroutingReportLoading());

    try {
      await rerouteMunicipalityUseCase(
        reportId: reportId,
        municipalityId: municipalityId,
      );
      emit(ActionReroutingReportSuccess());
    } catch (e) {
      emit(ActionReroutingReportFailure(error: e.toString()));
    }
  }
}
