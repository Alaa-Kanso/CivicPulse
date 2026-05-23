import 'package:equatable/equatable.dart';

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

class GetMunicipalitiesSuccess extends GetMunicipalitiesState {}
