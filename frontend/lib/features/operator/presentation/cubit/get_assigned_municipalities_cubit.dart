// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/features/operator/domain/useCases/get_municipalities_use_case.dart';
// import 'package:frontend/features/operator/presentation/cubit/get_assigned_municipalities_state.dart';
//
// class GetAssignedMunicipalitiesCubit extends Cubit<GetAssignedMunicipalitiesState> {
//   GetAssignedMunicipalitiesCubit({
//     required this.getAssignedMunicipalitiesUseCase,
//   }) : super(GetAssignedMunicipalitiesInitial());
//   final GetAssignedMunicipalitiesUseCase getAssignedMunicipalitiesUseCase;
//
//   Future<void> getAssignedMunicipalities() async {
//     emit(GetAssignedMunicipalitiesLoading());
//     try {
//       final municipalities = await getAssignedMunicipalitiesUseCase();
//       emit(GetAssignedMunicipalitiesSuccess(municipalities: municipalities));
//     } catch (e) {
//       emit(GetAssignedMunicipalitiesFailure(error: e.toString()));
//     }
//   }
// }
