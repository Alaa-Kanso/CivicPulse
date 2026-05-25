import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;
  final DateTime timestamp;

  SignUpError({required this.error}) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [error, timestamp];
}

class SignUpSuccess extends SignUpState {}

