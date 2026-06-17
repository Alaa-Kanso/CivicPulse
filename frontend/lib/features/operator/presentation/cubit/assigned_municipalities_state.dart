import 'package:equatable/equatable.dart';
import 'package:CivicPulse/features/operator/domain/entities/municipality.dart';

abstract class AssignedMunicipalitiesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AssignedMunicipalitiesInitial extends AssignedMunicipalitiesState {}

class AssignedMunicipalitiesLoading extends AssignedMunicipalitiesState {}

class AssignedMunicipalitiesFailure extends AssignedMunicipalitiesState {
  final String error;

  AssignedMunicipalitiesFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class AssignedMunicipalitiesSuccess extends AssignedMunicipalitiesState {
  final List<Municipality> municipalities;

  AssignedMunicipalitiesSuccess({required this.municipalities});

  @override
  List<Object?> get props => [municipalities];
}
