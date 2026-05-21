import 'package:dio/dio.dart';
import 'package:frontend/core/network/request_deduplicator.dart';

class ApiClient {
  final Dio dio;
  final RequestDeduplicator deduplicator;

  ApiClient({required this.dio, required this.deduplicator});

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    bool deduplicate = false,
    Options? options,
  }) {
    return _request<T>(
      method: 'GET',
      path: path,
      deduplicate: deduplicate,
      request: () async {
        final response = await dio.get(
          path,
          queryParameters: query,
          options: options,
        );
        return response.data as T;
      },
      query: query,
    );
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    bool deduplicate = false,
    Options? options,
  }) {
    return _request<T>(
      method: 'POST',
      path: path,
      deduplicate: deduplicate,
      request: () async {
        final response = await dio.post(path, data: data, options: options);
        return response.data as T;
      },
      data: data,
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    bool deduplicate = false,
    Options? options,
  }) {
    return _request<T>(
      method: 'PUT',
      path: path,
      deduplicate: deduplicate,
      request: () async {
        final response = await dio.put(path, data: data, options: options);
        return response.data as T;
      },
      data: data,
    );
  }

  Future<T> delete<T>(
    String path, {
    bool deduplicate = false,
    Options? options,
  }) {
     return _request<T>(
      method: 'DELETE',
      path: path,
      deduplicate: deduplicate,
      request: () async {
        final response = await dio.delete(path, options: options);
        return response.data as T;
      },
    );
  }

  Future<T> _request<T>({
    required String method,
    required String path,
    required Future<T> Function() request,
    bool deduplicate = false,
    Map<String, dynamic>? query,
    dynamic data,
  }) {
    final key = _generateKey(method, path, query, data);

    if (!deduplicate) {
      return request();
    }

    return deduplicator.run<T>(key, request);
  }

  String _generateKey(
    String method,
    String path,
    Map<String, dynamic>? query,
    dynamic data,
  ) {
    return '$method|$path|${query.toString()}|${data.toString()}';
  }
}
