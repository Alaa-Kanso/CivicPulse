import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class DeleteReportUseCase {
  final ReportRepository reportRepository;

  DeleteReportUseCase({required this.reportRepository});

  Future<void> call({required String reportId}) async {
    await reportRepository.deleteReport(reportId: reportId);
  }
}
