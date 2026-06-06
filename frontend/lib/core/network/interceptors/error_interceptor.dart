import 'package:dio/dio.dart';
import 'package:frontend/core/network/exceptions/api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _mapError(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
      ),
    );
  }

  ApiException _mapError(DioException e) {
    final response = e.response;
    final data = response?.data;

    if (response != null && data is Map) {
      final statusCode = response.statusCode;

      if (statusCode == 401) {
        return ApiException(
          message: data['message'] ?? "Unauthorized",
          type: ApiErrorType.unauthorized,
          statusCode: 401,
        );
      }

      if (data['errors'] != null) {
        return ApiException(
          message: _parseModelState(data['errors']),
          type: ApiErrorType.validation,
          errors: Map<String, dynamic>.from(data['errors']),
          statusCode: statusCode ?? 500,
        );
      }

      // 🧾 Generic server message
      return ApiException(
        message: data['message'] ?? "Server error",
        type: ApiErrorType.server,
        statusCode: statusCode ?? 500,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: "Connection timeout",
          type: ApiErrorType.timeout,
          statusCode: 500,
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Server timeout",
          type: ApiErrorType.timeout,
          statusCode: 500,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: "No internet connection",
          type: ApiErrorType.network,
          statusCode: 500,
        );

      default:
        return ApiException(
          message: "Unexpected error",
          type: ApiErrorType.unknown,
          statusCode: 500,
        );
    }
  }

  String _parseModelState(Map<String, dynamic> errors) {
    return errors.values.expand((e) => e is List ? e : [e]).join('\n');
  }
}
