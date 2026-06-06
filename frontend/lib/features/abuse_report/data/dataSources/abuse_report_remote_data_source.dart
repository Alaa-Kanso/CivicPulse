import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/abuse_report/data/models/abuse_report_details_model.dart';
import 'package:frontend/features/abuse_report/data/models/abuse_report_model.dart';
import 'package:frontend/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:frontend/features/abuse_report/domain/entities/abuse_report_details.dart';

class AbuseReportRemoteDataSource {
  final ApiClient apiClient;
  final String base = "/admin/moderation-cases";

  AbuseReportRemoteDataSource({required this.apiClient});

  Future<List<AbuseReport>> getAbuseReports() async {
    final response = await apiClient.get<List<dynamic>>(
      base,
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    List<AbuseReport> operatorReports = response
        .map((e) => AbuseReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return operatorReports;
  }

  Future<AbuseReportDetails> getAbuseReportDetails({required String id}) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      "$base/$id",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    return AbuseReportDetailsModel.fromJson(response);
  }

  Future<void> blockReportedUser({required String id}) async {
    await apiClient.patch(
      "$base/$id/block-user",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
  }

  Future<void> dismissReport({required String id}) async {
    await apiClient.patch(
      "$base/$id/dismiss",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
  }
}
