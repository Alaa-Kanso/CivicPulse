import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/device_info.dart';
import 'package:frontend/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDatasource {
  final ApiClient api;

  AuthRemoteDatasource({required this.api});

  Future<AuthResponseModel> signUp({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> response = await api.post("/auth/register", {
      "email": email,
      "password": password,
      "clientType": DeviceInfo.getDevicePlatform(),
    });
    return AuthResponseModel.fromJson(response);
  }

  Future<AuthResponseModel> logIn({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> response = await api.post("/auth/login", {
      "email": email,
      "password": password,
      "clientType": DeviceInfo.getDevicePlatform(),
    });
    return AuthResponseModel.fromJson(response);
  }
}
