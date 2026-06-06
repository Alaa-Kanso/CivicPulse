import 'package:CivicPulse/features/abuse_report/domain/repositories/abuse_report_repository.dart';

class DismissReportUseCase {
  final AbuseReportRepository abuseReportRepository;

  DismissReportUseCase({required this.abuseReportRepository});

  Future<void> call({required String id}) async {
    await abuseReportRepository.dismissReport(id: id);
  }
}
