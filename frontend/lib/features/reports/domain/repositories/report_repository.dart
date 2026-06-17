import 'dart:typed_data';

import 'package:CivicPulse/features/reports/data/models/report_type_model.dart';
import 'package:CivicPulse/features/reports/data/models/upload_image_init_model.dart';
import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report_details.dart';
import 'package:CivicPulse/features/reports/domain/entities/report.dart';

abstract class ReportRepository {
  Future<List<ReportTypeModel>> getCategoryTypes();

  Future<String> reverseGeocode({required double lat, required double lng});

  Future<UploadImageInitModel> getUploadImageInit({
    required String fileName,
    required String contentType,
  });

  Future<void> uploadImageToSupabase({
    required String imageKey,
    required String uploadUrl,
    required String fileExtension,
    required Uint8List fileBytes,
  });

  Future<void> createReport({
    required int reportTypeId,
    required double latitude,
    required double longitude,
    required String imageKey,
    required String description,
    required String addressDetails,
  });

  Future<List<Report>> getMyReports();

  Future<List<AdminRerouteReport>> getAdminReroutingReports();

  Future<void> deleteReport({required String reportId});

  Future<void> rerouteReport({
    required String reportId,
    required int municipalityId,
  });

  Future<List<OperatorReport>> getOperatorReports();

  Future<OperatorReportDetails> getOperatorReportDetails({required String id});

  Future<void> markAsSpam({required String reportId, required String reason});

  Future<void> markAsEscalate({
    required String reportId,
    required String reason,
  });

  Future<void> changeStatus({required String reportId, required String status});
}
