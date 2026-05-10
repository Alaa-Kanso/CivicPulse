import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnboardingPageManager extends OnboardingState {
  final int pageNb;

  OnboardingPageManager({required this.pageNb});

  @override
  // TODO: implement props
  List<Object?> get props => [pageNb];
}

class OnboardingSuccess extends OnboardingState {}
