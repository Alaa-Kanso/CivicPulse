import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/operator/domain/useCases/get_assigned_municipalities_use_case.dart';
import 'package:CivicPulse/features/operator/presentation/cubit/assigned_municipalities_state.dart';

class AssignedMunicipalitiesCubit extends Cubit<AssignedMunicipalitiesState> {
  AssignedMunicipalitiesCubit({required this.getAssignedMunicipalitiesUseCase})
    : super(AssignedMunicipalitiesInitial());

  final GetAssignedMunicipalitiesUseCase getAssignedMunicipalitiesUseCase;

  Future<void> getAssignedMunicipalities() async {
    emit(AssignedMunicipalitiesLoading());
    try {
      final municipalities = await getAssignedMunicipalitiesUseCase();
      emit(AssignedMunicipalitiesSuccess(municipalities: municipalities));
    } catch (e) {
      emit(AssignedMunicipalitiesFailure(error: e.toString()));
    }
  }
}
