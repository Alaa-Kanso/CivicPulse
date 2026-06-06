import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class GetAdminReroutingReportsUseCase {
  final ReportRepository repository;

  GetAdminReroutingReportsUseCase({required this.repository});

  Future<List<AdminRerouteReport>> call() async {
    return await repository.getAdminReroutingReports();
  }
}
