import 'package:equatable/equatable.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';

abstract class GetMunicipalitiesState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMunicipalitiesInitial extends GetMunicipalitiesState {}

class GetMunicipalitiesLoading extends GetMunicipalitiesState {}

class GetMunicipalitiesFailure extends GetMunicipalitiesState {
  final String error;

  GetMunicipalitiesFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class GetMunicipalitiesSuccess extends GetMunicipalitiesState {
  final List<Municipality> municipalities;

  GetMunicipalitiesSuccess({required this.municipalities});

  @override
  // TODO: implement props
  List<Object?> get props => [municipalities];
}
