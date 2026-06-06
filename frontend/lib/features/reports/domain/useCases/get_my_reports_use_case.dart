import 'package:CivicPulse/features/reports/domain/entities/report.dart';
import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class GetMyReportsUseCase {
  final ReportRepository repository;

  GetMyReportsUseCase({required this.repository});

  Future<List<Report>> call() async {
    return await repository.getMyReports();
  }
}
