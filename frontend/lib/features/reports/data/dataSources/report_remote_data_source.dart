import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/core/network/api_client.dart';
import 'package:CivicPulse/core/session/session_manager.dart';
import 'package:CivicPulse/features/reports/data/models/admin_reroute_report_model.dart';
import 'package:CivicPulse/features/reports/data/models/operator_report_details_model.dart';
import 'package:CivicPulse/features/reports/data/models/operator_report_model.dart';
import 'package:CivicPulse/features/reports/data/models/report_model.dart';
import 'package:CivicPulse/features/reports/data/models/report_type_model.dart';
import 'package:CivicPulse/features/reports/data/models/upload_image_init_model.dart';
import 'package:CivicPulse/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report.dart';
import 'package:CivicPulse/features/reports/domain/entities/operator_report_details.dart';

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

  Future<List<AdminRerouteReport>> getAdminReroutingReports() async {
    final response = await apiClient.get<List<dynamic>>(
      "/admin/unmapped-reports",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    List<AdminRerouteReport> adminReports = response
        .map((e) => AdminRerouteReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return adminReports;
  }

  Future<void> deleteReport({required String reportId}) async {
    await apiClient.delete(
      "/admin/unmapped-reports/$reportId",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
  }

  Future<void> rerouteReport({
    required String reportId,
    required int municipalityId,
  }) async {
    await apiClient.patch(
      "/admin/unmapped-reports/$reportId/reroute",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
      data: {"municipalityId": municipalityId},
    );
  }

  Future<List<OperatorReport>> getOperatorReports() async {
    final response = await apiClient.get<List<dynamic>>(
      "/operator/reports",
      options: Options(extra: {"noAuth": false}),
      deduplicate: true,
      query: {"isSpam": false},
    );
    List<OperatorReport> operatorReports = response
        .map((e) => OperatorReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return operatorReports;
  }

  Future<OperatorReportDetails> getOperatorReportDetails({
    required String id,
  }) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      "/operator/reports/$id",
      options: Options(extra: {"noAuth": false}),
      deduplicate: true,
    );
    return OperatorReportDetailsModel.fromJson(response);
  }

  Future<void> markAsSpam({
    required String reportId,
    required String reason,
  }) async {
    await apiClient.post(
      "/operator/reports/$reportId/spam",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
      data: {"reason": reason},
    );
  }

  Future<void> markAsEscalate({
    required String reportId,
    required String reason,
  }) async {
    await apiClient.post(
      "/operator/reports/$reportId/escalate",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
      data: {"reason": reason},
    );
  }Future<void> changeStatus({
    required String reportId,
    required String status,
  }) async {
    await apiClient.patch(
      "/operator/reports/$reportId/status",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
      data: {"status": status},
    );
  }
}
