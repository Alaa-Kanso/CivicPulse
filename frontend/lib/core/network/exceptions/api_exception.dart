enum ApiErrorType {
  network,
  timeout,
  validation,
  server,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.type,
    this.errors,
  });

  @override
  String toString() => message;
}