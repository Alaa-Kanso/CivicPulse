import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;

  SignUpError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class SignUpSuccess extends SignUpState {}
