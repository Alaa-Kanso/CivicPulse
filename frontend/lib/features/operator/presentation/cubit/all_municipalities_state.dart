import 'package:equatable/equatable.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';

abstract class AllMunicipalitiesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AllMunicipalitiesInitial extends AllMunicipalitiesState {}

class AllMunicipalitiesLoading extends AllMunicipalitiesState {}

class AllMunicipalitiesFailure extends AllMunicipalitiesState {
  final String error;

  AllMunicipalitiesFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class AllMunicipalitiesSuccess extends AllMunicipalitiesState {
  final List<Municipality> municipalities;

  AllMunicipalitiesSuccess({required this.municipalities});

  @override
  // TODO: implement props
  List<Object?> get props => [municipalities];
}
