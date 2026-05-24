import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/operator/data/models/municipality_model.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';

class OperatorRemoteDataSource {
  final ApiClient apiClient;

  OperatorRemoteDataSource({required this.apiClient});

  Future<void> createOperator({
    required String email,
    required String password,
    required int municipalityId,
  }) async {
    await apiClient.post(
      "/admin/operators",
      deduplicate: true,
      data: {
        'email': email,
        'password': password,
        'assignedMunicipalityId': municipalityId,
      },
      options: Options(extra: {"noAuth": false}),
    );
  }

  Future<List<Municipality>> getMunicipalities() async {
    final response = await apiClient.get(
      "/admin/reroute-target-municipalities",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
    return MunicipalityModel.fromJsonList(response);
  }
}
