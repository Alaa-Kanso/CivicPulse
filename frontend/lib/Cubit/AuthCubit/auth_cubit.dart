import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Cubit/AuthCubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
  AuthCubit() : super(AuthInitial());

}