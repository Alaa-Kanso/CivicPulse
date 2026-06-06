import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/reports/domain/useCases/geocoding_location_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/operator_report_details_use_case.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_report_details_state.dart';
import 'package:permission_handler/permission_handler.dart';

class OperatorReportDetailsCubit extends Cubit<OperatorReportDetailsState> {
  OperatorReportDetailsCubit({
    required this.operatorReportDetailsUseCase,
    required this.geocodingLocationUseCase,
  }) : super(OperatorReportDetailsInitial());

  final OperatorReportDetailsUseCase operatorReportDetailsUseCase;
  final GeocodingLocationUseCase geocodingLocationUseCase;

  Future<void> getReportDetails({required String id}) async {
    emit(OperatorReportDetailsLoading());
    handlePermission();
    try {
      final report = await operatorReportDetailsUseCase(id: id);
      emit(OperatorReportDetailsSuccess(reportDetails: report));
    } catch (e) {
      emit(OperatorReportDetailsError(error: e.toString()));
    }
  }

  Future<void> handlePermission()async{
    if(!await Permission.location.isGranted){
      await Permission.location.request();
    }
  }
}
