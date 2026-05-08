import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticatedGoHome extends AuthState {
  final User user;

  AuthAuthenticatedGoHome({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class AuthAuthenticatedGoBoarding extends AuthState {}

class AuthUnAuthenticated extends AuthState {}
