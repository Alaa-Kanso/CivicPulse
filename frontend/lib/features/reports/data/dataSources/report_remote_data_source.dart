import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/reports/data/models/report_model.dart';
import 'package:frontend/features/reports/data/models/report_type_model.dart';
import 'package:frontend/features/reports/data/models/upload_image_init_model.dart';

class ReportRemoteDataSource {
  final ApiClient apiClient;
  final SessionManager sessionManager = sl<SessionManager>();

  ReportRemoteDataSource({required this.apiClient});

  Future<List<ReportModel>> getMyReports() async {
    final response = await apiClient.get<List<dynamic>>(
      "/reports/my",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    List<ReportModel> myReports = response
        .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return myReports;
  }

  Future<List<ReportTypeModel>> getCategoryTypes() async {
    final response = await apiClient.get<List<dynamic>>(
      "/report-types",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    return response
        .map((e) => ReportTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UploadImageInitModel> getUploadImageInit({
    required String fileName,
    required String contentType,
  }) async {
    final response = await apiClient.post<dynamic>(
      "/uploads/report-image/init",
      deduplicate: true,
      data: {"FileName": fileName, "ContentType": contentType},
      options: Options(extra: {"noAuth": false}),
    );
    return UploadImageInitModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> uploadImageToSupabase({
    required String imageKey,
    required String uploadUrl,
    required String fileExtension,
    required Uint8List fileBytes,
  }) async {
    try {
      await apiClient.put(
        uploadUrl,
        deduplicate: true,
        data: fileBytes,
        options: Options(headers: {'Content-Type': fileExtension}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createReport({
    required int reportTypeId,
    required double latitude,
    required double longitude,
    required String imageKey,
    required String description,
    required String addressDetails,
  }) async {
    try {
      await apiClient.post(
        "/reports",
        data: {
          "reportTypeId": reportTypeId,
          "latitude": latitude,
          "longitude": longitude,
          "imageKey": imageKey,
          "description": description,
          "addressDetails": addressDetails,
        },
        deduplicate: true,
        options: Options(extra: {"noAuth": false}),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
