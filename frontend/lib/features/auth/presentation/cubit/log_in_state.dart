import 'package:equatable/equatable.dart';

abstract class LogInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogInInitial extends LogInState {}

class LogInLoading extends LogInState {}

class LogInError extends LogInState {
  final String error;
  final DateTime timestamp;

  LogInError({required this.error}) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [error, timestamp];
}

class LogInSuccess extends LogInState {}

