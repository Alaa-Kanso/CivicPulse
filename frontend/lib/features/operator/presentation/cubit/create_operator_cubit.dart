import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_state.dart';

class CreateOperatorCubit extends Cubit<CreateOperatorState> {
  CreateOperatorCubit() : super(CreateOperatorInitial());

  Future<void> createOperator({
    required String email,
    required String password,
    required String municipality,
  }) async {
    emit(CreateOperatorLoading());
    // emit(CreateOperatorSuccess());
    // emit(CreateOperatorFailure(error: "Failure when creating operator")) ;
  }
}
