import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/reports/domain/useCases/change_status_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/mark_as_escalate_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/mark_as_spam_use_case.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_manager_state.dart';

class OperatorManagerCubit extends Cubit<OperatorManagerState> {
  OperatorManagerCubit({
    required this.markAsSpamUseCase,
    required this.markAsEscalateUseCase,
    required this.changeStatusUseCase,
  }) : super(OperatorManagerInitial());
  final MarkAsSpamUseCase markAsSpamUseCase;
  final MarkAsEscalateUseCase markAsEscalateUseCase;
  final ChangeStatusUseCase changeStatusUseCase;

  Future<void> markAsSpam({
    required String reportId,
    required String reason,
  }) async {
    if (reason.isEmpty) {
      emit(OperatorManagerFailure(error: "provide a reason"));
      return;
    }
    emit(OperatorManagerLoading());
    try {
      await markAsSpamUseCase(reportId: reportId, reason: reason);
      emit(OperatorManagerSuccess(message: "Report marked as spam: $reason"));
    } catch (e) {
      emit(OperatorManagerFailure(error: e.toString()));
    }
  }

  Future<void> markAsEscalate({
    required String reportId,
    required String reason,
  }) async {
    if (reason.isEmpty) {
      emit(OperatorManagerFailure(error: "provide a reason"));
      return;
    }
    emit(OperatorManagerLoading());
    try {
      await markAsEscalateUseCase(reportId: reportId, reason: reason);
      emit(
        OperatorManagerSuccess(message: "Report marked as escalate: $reason"),
      );
    } catch (e) {
      emit(OperatorManagerFailure(error: e.toString()));
    }
  }

  Future<void> changeStatus({
    required String reportId,
    required String status,
  }) async {
    emit(OperatorManagerLoading());
    try {
      await changeStatusUseCase(reportId: reportId, status: status);
      emit(OperatorManagerSuccess(message: "Status Changed to $status"));
    } catch (e) {
      emit(OperatorManagerFailure(error: e.toString()));
    }
  }
}
