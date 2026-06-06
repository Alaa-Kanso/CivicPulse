import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:CivicPulse/features/abuse_report/domain/repositories/abuse_report_repository.dart';

class GetAbuseReportUseCase {
  final AbuseReportRepository abuseReportRepository;

  GetAbuseReportUseCase({required this.abuseReportRepository});

  Future<List<AbuseReport>> call() async {
    return await abuseReportRepository.getAbuseReports();
  }
}
