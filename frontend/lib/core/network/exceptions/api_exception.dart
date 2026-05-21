enum ApiErrorType {
  network,
  timeout,
  validation,
  unauthorized,
  server,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final Map<String, dynamic>? errors;
  final int statusCode;

  ApiException({
    required this.message,
    required this.type,
    this.errors,
    required this.statusCode,
  });

  @override
  String toString() => message;
}
