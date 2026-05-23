import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/operator/domain/useCases/get_municipalities_use_case.dart';
import 'package:frontend/features/operator/presentation/cubit/get_municipalities_state.dart';

class GetMunicipalitiesCubit extends Cubit<GetMunicipalitiesState> {
  GetMunicipalitiesCubit({required this.getMunicipalitiesUseCase})
    : super(GetMunicipalitiesInitial());
  final GetMunicipalitiesUseCase getMunicipalitiesUseCase;

  Future<void> getMunicipalities() async {
    emit(GetMunicipalitiesLoading());
    try {
      await getMunicipalitiesUseCase();
      emit(GetMunicipalitiesSuccess());
    } catch (e) {
      emit(GetMunicipalitiesFailure(error:e.toString()));
    }
  }
}
