import 'package:dio/dio.dart';

class TraceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🟡 [onRequest]");
    print("   baseUrl: ${options.baseUrl}");
    print("   path: ${options.path}");
    print("   uri: ${options.uri}");
    super.onRequest(options, handler);
    print("=== REQUEST HEADERS ===");
    print(options.headers);
    print("EXTRA IN INTERCEPTOR => ${options.extra}");
    print("DATA IN INTERCEPTOR => ${options.data}");
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("🟢 [onResponse] ${response.requestOptions.uri}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("🔴 [onError]");
    print("   uri: ${err.requestOptions.uri}");
    print("   message: ${err.message}");
    super.onError(err, handler);
  }
}