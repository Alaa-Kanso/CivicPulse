import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.sessionManager}) : super(AuthInitial());

  final SessionManager sessionManager;

  void checkAuthenticated(){
    if(sessionManager.isAuthenticated){
      setAuthenticated(sessionManager.user!);
      return;
    }
    setUnAuthenticated();
  }
  void setAuthenticated(User user) {
    emit(AuthAuthenticated(user: user));
  }
  void setUnAuthenticated(){
    emit(AuthUnAuthenticated());
  }
}
