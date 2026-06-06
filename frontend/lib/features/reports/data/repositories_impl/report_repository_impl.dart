import 'dart:typed_data';

import 'package:frontend/features/reports/data/dataSources/report_remote_data_source.dart';
import 'package:frontend/features/reports/data/models/report_type_model.dart';
import 'package:frontend/features/reports/data/models/upload_image_init_model.dart';
import 'package:frontend/features/reports/domain/entities/admin_reroute_report.dart';
import 'package:frontend/features/reports/domain/entities/operator_report.dart';
import 'package:frontend/features/reports/domain/entities/operator_report_details.dart';
import 'package:frontend/features/reports/domain/entities/report.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';
import 'package:geocoding/geocoding.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportRemoteDataSource reportRemoteDataSource;

  ReportRepositoryImpl({required this.reportRemoteDataSource});

  @override
  Future<List<ReportTypeModel>> getCategoryTypes() async {
    return await reportRemoteDataSource.getCategoryTypes();
  }

  @override
  Future<String> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isEmpty) {
      return "Unknown location";
    }

    final place = placemarks.first;

    return [
      place.name,
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
    ].where((e) => e != null && e.isNotEmpty).toSet().join(", ");
  }

  @override
  Future<UploadImageInitModel> getUploadImageInit({
    required String fileName,
    required String contentType,
  }) async {
    final UploadImageInitModel data = await reportRemoteDataSource
        .getUploadImageInit(fileName: fileName, contentType: contentType);
    return data;
  }

  @override
  Future<void> uploadImageToSupabase({
    required String imageKey,
    required String uploadUrl,
    required fileExtension,

    required Uint8List fileBytes,
  }) async {
    await reportRemoteDataSource.uploadImageToSupabase(
      imageKey: imageKey,
      uploadUrl: uploadUrl,
      fileBytes: fileBytes,
      fileExtension: fileExtension,
    );
  }

  @override
  Future<void> createReport({
    required int reportTypeId,
    required double latitude,
    required double longitude,
    required String imageKey,
    required String description,
    required String addressDetails,
  }) async {
    await reportRemoteDataSource.createReport(
      reportTypeId: reportTypeId,
      latitude: latitude,
      longitude: longitude,
      imageKey: imageKey,
      description: description,
      addressDetails: addressDetails,
    );
  }

  @override
  Future<List<Report>> getMyReports() async {
    return await reportRemoteDataSource.getMyReports();
  }

  @override
  Future<List<AdminRerouteReport>> getAdminReroutingReports() async {
    return await reportRemoteDataSource.getAdminReroutingReports();
  }

  @override
  Future<void> deleteReport({required String reportId}) async {
    await reportRemoteDataSource.deleteReport(reportId: reportId);
  }

  @override
  Future<void> rerouteReport({
    required String reportId,
    required int municipalityId,
  }) async {
    await reportRemoteDataSource.rerouteReport(
      reportId: reportId,
      municipalityId: municipalityId,
    );
  }

  @override
  Future<List<OperatorReport>> getOperatorReports() async {
    return await reportRemoteDataSource.getOperatorReports();
  }

  @override
  Future<OperatorReportDetails> getOperatorReportDetails({
    required String id,
  }) async {
    return await reportRemoteDataSource.getOperatorReportDetails(id: id);
  }

  @override
  Future<void> markAsSpam({
    required String reportId,
    required String reason,
  }) async {
    await reportRemoteDataSource.markAsSpam(reportId: reportId, reason: reason);
  }

  @override
  Future<void> markAsEscalate({
    required String reportId,
    required String reason,
  }) async {
    await reportRemoteDataSource.markAsEscalate(
      reportId: reportId,
      reason: reason,
    );
  }

  @override
  Future<void> changeStatus({
    required String reportId,
    required String status,
  }) async {
    await reportRemoteDataSource.changeStatus(
      reportId: reportId,
      status: status,
    );
  }
}
