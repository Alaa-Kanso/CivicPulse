import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/domain/useCases/log_in_use_case.dart';
import 'package:frontend/features/auth/presentation/cubit/log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit({required this.logInUseCase}) : super(LogInInitial());

  final LogInUseCase logInUseCase;

  Future<void> logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LogInError(error: "All fields are required"));
      return;
    }
    if (!email.contains("@")) {
      emit(LogInError(error: "Invalid email address"));
      return;
    }
    emit(LogInLoading());
    try {
      await logInUseCase.call(email, password);
      emit(LogInSuccess());
    } catch (e) {
      print(e.toString());
      emit(LogInError(error: e.toString()));
    }
  }
}
