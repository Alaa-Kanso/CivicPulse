import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/block_reported_user_use_case.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/dismiss_report_use_case.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_actions_state.dart';

class AbuseReportActionsCubit extends Cubit<AbuseReportActionsState> {
  AbuseReportActionsCubit({
    required this.blockReportedUserUseCase,
    required this.dismissReportUseCase,
  }) : super(AbuseReportActionsInitial());
  final BlockReportedUserUseCase blockReportedUserUseCase;
  final DismissReportUseCase dismissReportUseCase;

  Future<void> blockUser({required String id}) async {
    emit(AbuseReportActionsLoading());
    try {
      await blockReportedUserUseCase(id: id);
      emit(AbuseReportActionsSuccess(message: "User blocked successfully."));
    } catch (e) {
      emit(AbuseReportActionsFailure(error: e.toString()));
    }
  }

  Future<void> dismissAbuseReport({required String id}) async {
    emit(AbuseReportActionsLoading());
    try {
      await dismissReportUseCase(id: id);
      emit(
        AbuseReportActionsSuccess(
          message: "Abuse report dismissed successfully.",
        ),
      );
    } catch (e) {
      emit(AbuseReportActionsFailure(error: e.toString()));
    }
  }
}
