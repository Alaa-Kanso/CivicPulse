import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class AuthUnAuthenticated extends AuthState {}
