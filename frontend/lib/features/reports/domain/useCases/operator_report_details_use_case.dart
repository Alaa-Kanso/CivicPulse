import 'package:frontend/features/reports/domain/entities/operator_report_details.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class OperatorReportDetailsUseCase {
  final ReportRepository reportRepository;

  OperatorReportDetailsUseCase({required this.reportRepository});

  Future<OperatorReportDetails> call({required String id})async{
    return await reportRepository.getOperatorReportDetails(id: id);
  }
}