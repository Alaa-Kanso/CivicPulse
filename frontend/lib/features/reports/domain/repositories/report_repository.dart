import 'dart:typed_data';

import 'package:frontend/features/reports/data/models/report_type_model.dart';
import 'package:frontend/features/reports/data/models/upload_image_init_model.dart';
import 'package:frontend/features/reports/domain/entities/report.dart';

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
}
