import 'package:dio/dio.dart';
import 'package:CivicPulse/core/session/session_manager.dart';

class AuthInterceptor extends Interceptor {
  final SessionManager sessionManager;

  AuthInterceptor({required this.sessionManager});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final noAuth = options.extra['noAuth'] == true;
    if (noAuth) {
      return handler.next(options);
    }

    final token = sessionManager.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
