import 'package:dio/dio.dart';
import 'package:CivicPulse/core/network/api_client.dart';
import 'package:CivicPulse/features/operator/data/models/municipality_model.dart';
import 'package:CivicPulse/features/operator/domain/entities/municipality.dart';

class MunicipalityRemoteDataSource {
  final ApiClient apiClient;

  MunicipalityRemoteDataSource({required this.apiClient});

  Future<List<Municipality>> getAllMunicipalities() async {
    final response = await apiClient.get(
      "/admin/operators/available-municipalities",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    return MunicipalityModel.fromJsonList(response);
  }

  Future<List<Municipality>> getAssignedMunicipalities() async {
    final response = await apiClient.get(
      "/admin/reroute-target-municipalities",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    return MunicipalityModel.fromJsonList(response);
  }
}
