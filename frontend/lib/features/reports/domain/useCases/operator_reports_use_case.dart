import 'package:CivicPulse/features/reports/domain/entities/operator_report.dart';
import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class OperatorReportsUseCase {
  final ReportRepository reportRepository;

  OperatorReportsUseCase({required this.reportRepository});

  Future<List<OperatorReport>> call() async {
    return await reportRepository.getOperatorReports();
  }
}
