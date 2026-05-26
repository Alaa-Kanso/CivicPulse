import 'package:equatable/equatable.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';

abstract class GetAssignedMunicipalitiesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAssignedMunicipalitiesInitial extends GetAssignedMunicipalitiesState {}

class GetAssignedMunicipalitiesLoading extends GetAssignedMunicipalitiesState {}

class GetAssignedMunicipalitiesFailure extends GetAssignedMunicipalitiesState {
  final String error;

  GetAssignedMunicipalitiesFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class GetAssignedMunicipalitiesSuccess extends GetAssignedMunicipalitiesState {
  final List<Municipality> municipalities;

  GetAssignedMunicipalitiesSuccess({required this.municipalities});

  @override
  // TODO: implement props
  List<Object?> get props => [municipalities];
}
