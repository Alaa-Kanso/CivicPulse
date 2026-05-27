import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class RerouteMunicipalityUseCase {
  final ReportRepository reportRepository;

  RerouteMunicipalityUseCase({required this.reportRepository});

  Future<void> call({
    required String reportId,
    required int municipalityId,
  }) async {
    await reportRepository.rerouteReport(
      reportId: reportId,
      municipalityId: municipalityId,
    );
  }
}
