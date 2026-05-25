import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/reports/presentation/cubit/rerouting_report_state.dart';

class ReroutingReportCubit extends Cubit<ReroutingReportState> {
  ReroutingReportCubit() : super(ReroutingReportInitial());
}
