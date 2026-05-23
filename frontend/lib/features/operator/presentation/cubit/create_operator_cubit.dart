import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/operator/domain/useCases/create_operator_use_case.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_state.dart';

class CreateOperatorCubit extends Cubit<CreateOperatorState> {
  CreateOperatorCubit({required this.createOperatorUseCase})
    : super(CreateOperatorInitial());

  final CreateOperatorUseCase createOperatorUseCase;

  Future<void> createOperator({
    required String email,
    required String password,
    required String municipality,
  }) async {
    emit(CreateOperatorLoading());
    if (email.isEmpty || password.isEmpty || municipality.isEmpty) {
      emit(CreateOperatorFailure(error: "All fields are required"));
      return;
    }
    if (password.length < 8 || password.length > 100) {
      emit(
        CreateOperatorFailure(
          error: "Password length should be between 8 and 100",
        ),
      );
      return;
    }
    if (!email.contains("@")) {
      emit(CreateOperatorFailure(error: "Invalid email address"));
      return;
    }
    try {
      await createOperatorUseCase(
        email: email,
        password: password,
        municipalityId: 10,
      );
      emit(CreateOperatorSuccess());
    } catch (e) {
      emit(CreateOperatorFailure(error: e.toString()));
    }
  }
}
