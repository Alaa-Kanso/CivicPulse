import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class ChangeStatusUseCase {
  final ReportRepository reportRepository;

  ChangeStatusUseCase({required this.reportRepository});

  Future<void> call({required String reportId, required String status}) async {
    await reportRepository.changeStatus(reportId: reportId, status: status);
  }
}
