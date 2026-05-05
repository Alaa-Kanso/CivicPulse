import 'package:dio/dio.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.0.197:5139/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    return dio;
  }
}