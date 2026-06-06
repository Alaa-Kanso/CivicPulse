import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class CreateReportUseCase {
  final ReportRepository repository;

  CreateReportUseCase({required this.repository});

  Future<void> call({
    required int reportTypeId,
    required double latitude,
    required double longitude,
    required String imageKey,
    required String description,
    required String addressDetails,
  }) async {
    await repository.createReport(
      reportTypeId: reportTypeId,
      latitude: latitude,
      longitude: longitude,
      imageKey: imageKey,
      description: description,
      addressDetails: addressDetails,
    );
  }
}
