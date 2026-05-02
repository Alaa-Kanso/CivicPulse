import 'package:equatable/equatable.dart';

abstract class LogInState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LogInInitial extends LogInState {}

class LogInLoading extends LogInState {}

class LogInError extends LogInState {
  final String error;

  LogInError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class LogInSuccess extends LogInState {}
