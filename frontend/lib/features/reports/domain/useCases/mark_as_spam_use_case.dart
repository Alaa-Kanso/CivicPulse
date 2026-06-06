import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class MarkAsSpamUseCase {
  final ReportRepository reportRepository;

  MarkAsSpamUseCase({required this.reportRepository});
  Future<void> call({required String reportId,required String reason})async{
    await reportRepository.markAsSpam(reportId:reportId, reason: reason);
  }
}