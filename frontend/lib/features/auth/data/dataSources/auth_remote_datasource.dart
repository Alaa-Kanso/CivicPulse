import 'package:dio/dio.dart';
import 'package:CivicPulse/core/network/api_client.dart';
import 'package:CivicPulse/device_info.dart';
import 'package:CivicPulse/features/auth/data/models/auth_response_model.dart';
import 'package:CivicPulse/features/auth/data/models/refresh_response_model.dart';

class AuthRemoteDatasource {
  final ApiClient api;

  AuthRemoteDatasource({required this.api});

  Future<AuthResponseModel> signUp({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> response = await api.post<Map<String, dynamic>>(
      "/auth/register",
      data: {
        "email": email,
        "password": password,
        "clientType": DeviceInfo.getDevicePlatform(),
      },
      deduplicate: true,
      options: Options(extra: {'noAuth': true}),
    );
    return AuthResponseModel.fromJson(response);
  }

  Future<AuthResponseModel> logIn({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> response = await api.post<Map<String, dynamic>>(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
        "clientType": DeviceInfo.getDevicePlatform(),
      },
      deduplicate: true,
      options: Options(extra: {'noAuth': true}),
    );

    return AuthResponseModel.fromJson(response);
  }

  Future<RefreshResponseModel> refresh({
    required String refreshToken,
    required String deviceType,
  }) async {
    final Map<String, dynamic> response = await api.post<Map<String, dynamic>>(
      "/auth/refresh",
      data: {"refreshToken": refreshToken, "clientType": deviceType},
      deduplicate: true,
      options: Options(extra: {"noAuth": true}),
    );

    return RefreshResponseModel.fromJson(response);
  }

  Future<void> logout({required String refreshToken}) async {
    await api.post(
      "/auth/logout",
      data: {
        "refreshToken": refreshToken,
        "clientType": DeviceInfo.getDevicePlatform(),
      },
      deduplicate: true,
    );
  }
}
