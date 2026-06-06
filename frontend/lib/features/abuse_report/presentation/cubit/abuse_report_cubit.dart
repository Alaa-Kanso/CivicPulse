import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:frontend/features/abuse_report/domain/useCases/get_abuse_report_use_case.dart';
import 'package:frontend/features/abuse_report/presentation/cubit/abuse_report_state.dart';

class AbuseReportCubit extends Cubit<AbuseReportState> {
  AbuseReportCubit({required this.getAbuseReportUseCase})
    : super(AbuseReportInitial());
  final GetAbuseReportUseCase getAbuseReportUseCase;

  Future<void> getAbuseReports() async {
    emit(AbuseReportLoading());
    try {
      final List<AbuseReport> reports = await getAbuseReportUseCase();
      emit(AbuseReportSuccess(abuseReports: reports));
    } catch (e) {
      emit(AbuseReportError(error: e.toString()));
    }
  }
}
