import 'package:equatable/equatable.dart';

abstract class CreateOperatorState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateOperatorInitial extends CreateOperatorState {}

class CreateOperatorLoading extends CreateOperatorState {}

class CreateOperatorFailure extends CreateOperatorState {
  final String error;

  CreateOperatorFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class CreateOperatorSuccess extends CreateOperatorState {}
