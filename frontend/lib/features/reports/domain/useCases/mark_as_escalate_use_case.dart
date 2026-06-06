import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class MarkAsEscalateUseCase {
  final ReportRepository reportRepository;

  MarkAsEscalateUseCase({required this.reportRepository});

  Future<void> call({required String reportId, required String reason}) async {
    await reportRepository.markAsEscalate(reportId: reportId, reason: reason);
  }
}
