import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
