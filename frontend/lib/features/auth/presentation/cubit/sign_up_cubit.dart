import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:frontend/features/auth/presentation/cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.signUpUseCase}) : super(SignUpInitial());
  final SignUpUseCase signUpUseCase;

  Future<void> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      emit(SignUpError(error: 'All fields should be filled'));
      return;
    }
    if (!email.contains("@")) {
      emit(SignUpError(error: 'Invalid email address'));
      return;
    }
    if (password.length < 8) {
      emit(SignUpError(error: 'Password length should be at least 8'));
      return;
    }
    if (password != confirmPassword) {
      emit(SignUpError(error: 'Password and Confirm password should match'));
      return;
    }
    emit(SignUpLoading());
    try {
      await signUpUseCase.call(email, password);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpError(error: e.toString()));
    }
  }
}
