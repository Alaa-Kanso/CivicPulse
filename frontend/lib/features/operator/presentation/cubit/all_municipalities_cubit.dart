import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/operator/domain/useCases/get_all_municipalities_use_case.dart';
import 'package:CivicPulse/features/operator/presentation/cubit/all_municipalities_state.dart';

class AllMunicipalitiesCubit extends Cubit<AllMunicipalitiesState> {
  AllMunicipalitiesCubit({required this.getMunicipalitiesUseCase})
    : super(AllMunicipalitiesInitial());
  final GetAllMunicipalitiesUseCase getMunicipalitiesUseCase;

  Future<void> getAllMunicipalities() async {
    emit(AllMunicipalitiesLoading());
    try {
      final municipalities = await getMunicipalitiesUseCase();
      emit(AllMunicipalitiesSuccess(municipalities: municipalities));
    } catch (e) {
      emit(AllMunicipalitiesFailure(error: e.toString()));
    }
  }
}
