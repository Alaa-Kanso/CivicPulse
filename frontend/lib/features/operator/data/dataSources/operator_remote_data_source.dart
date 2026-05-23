import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';

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

  Future<void> getMunicipalities() async {
    final response = await apiClient.get(
      "/",
      deduplicate: true,
      options: Options(extra: {"noAuth": false}),
    );
  }
}
