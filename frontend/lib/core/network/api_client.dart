import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/core/network/errors/error_handler.dart';
import 'package:frontend/core/network/request_deduplicator.dart';

class ApiClient {
  final Dio dio;

  final RequestDeduplicator deduplicator;

  ApiClient({required this.dio, required this.deduplicator});

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final sortedData = Map.fromEntries(
      data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final key = "POST:$path:${jsonEncode(sortedData)}";

    return deduplicator.run(key, () async {
      try {
        final response = await dio.post(path, data: data);
        return response.data;
      } on DioException catch (e) {
        throw ErrorHandler.handle(e);
      }
    });
  }
}
