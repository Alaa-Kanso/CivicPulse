import 'package:CivicPulse/features/abuse_report/domain/repositories/abuse_report_repository.dart';

class BlockReportedUserUseCase {
  final AbuseReportRepository abuseReportRepository;

  BlockReportedUserUseCase({required this.abuseReportRepository});

  Future<void> call({required String id}) async {
    await abuseReportRepository.blockReportedUser(id: id);
  }
}
