import 'package:dio/dio.dart';
import 'package:frontend/core/network/exceptions/api_exception.dart';

class ErrorHandler {
  static ApiException handle(DioException e) {
    final response = e.response;

    if (response != null && response.data is Map) {
      final data = response.data;

      // ✅ ModelState (validation errors)
      if (data['errors'] != null) {
        return ApiException(
          message: _parseModelState(data['errors']),
          type: ApiErrorType.validation,
          errors: Map<String, dynamic>.from(data['errors']),
        );
      }

      return ApiException(
        message: data['message'] ?? "Server error",
        type: ApiErrorType.server,
      );
    }

    // 🔵 Network / timeout errors
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Request timed out. Please try again.",
          type: ApiErrorType.timeout,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: "No internet connection",
          type: ApiErrorType.network,
        );

      case DioExceptionType.unknown:
        return ApiException(
          message: "No internet connection",
          type: ApiErrorType.network,
        );

      default:
        return ApiException(
          message: "Unexpected error",
          type: ApiErrorType.unknown,
        );
    }
  }

  static String _parseModelState(Map errors) {
    return errors.values.expand((e) => e).join('\n');
  }
}
