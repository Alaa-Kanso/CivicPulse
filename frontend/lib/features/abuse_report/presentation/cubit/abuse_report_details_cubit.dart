import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report_details.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/get_abuse_report_details_use_case.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_details_state.dart';

class AbuseReportDetailsCubit extends Cubit<AbuseReportDetailsState> {
  AbuseReportDetailsCubit({required this.getAbuseReportDetailsUseCase})
    : super(AbuseReportDetailsInitial());
  final GetAbuseReportDetailsUseCase getAbuseReportDetailsUseCase;

  Future<void> getReportDetails({required String id}) async {
    emit(AbuseReportDetailsLoading());
    try {
      final AbuseReportDetails reportDetails =
          await getAbuseReportDetailsUseCase(id: id);
      emit(AbuseReportDetailsSuccess(reportDetails: reportDetails));
    } catch (e) {
      emit(AbuseReportDetailsError(error: e.toString()));
    }
  }
}
