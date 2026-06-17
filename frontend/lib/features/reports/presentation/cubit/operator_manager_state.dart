import 'package:equatable/equatable.dart';

abstract class OperatorManagerState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OperatorManagerInitial extends OperatorManagerState {}

class OperatorManagerLoading extends OperatorManagerState {}

class OperatorManagerFailure extends OperatorManagerState {
  final String error;

  OperatorManagerFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class OperatorManagerSuccess extends OperatorManagerState {
  final String message;

  OperatorManagerSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
