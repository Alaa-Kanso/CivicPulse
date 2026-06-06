import 'package:frontend/features/abuse_report/domain/entities/abuse_report_details.dart';
import 'package:frontend/features/abuse_report/domain/repositories/abuse_report_repository.dart';

class GetAbuseReportDetailsUseCase {
  final AbuseReportRepository abuseReportRepository;

  GetAbuseReportDetailsUseCase({required this.abuseReportRepository});

  Future<AbuseReportDetails> call({required String id}) async {
    return await abuseReportRepository.getAbuseReportDetails(id: id);
  }
}
