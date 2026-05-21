import 'dart:async';

import 'package:dio/dio.dart';
import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:frontend/features/auth/data/utils/token_decoder.dart';

class RefreshInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;
  final SessionManager sessionManager;

  Dio get _dio => sl<Dio>();

  bool _isRefreshing = false;
  final List<_RetryRequest> _queue = [];

  RefreshInterceptor({
    required this.authLocalDataSource,
    required this.sessionManager,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    // ❌ refresh endpoint failed → logout
    if (options.path.contains('/auth/refresh')) {
      final statusCode = err.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        await _logout();
      }

      return handler.next(err);
    }
    if (statusCode != 401) {
      return handler.next(err);
    }
    final response = await _handleRefreshAndRetry(options);

    if (response != null) {
      return handler.resolve(response);
    }

    return handler.next(err);
  }

  // =========================
  // 🔄 REFRESH + RETRY FLOW
  // =========================
  Future<Response?> _handleRefreshAndRetry(RequestOptions failedRequest) async {
    final completer = Completer<Response>();

    _queue.add(_RetryRequest(request: failedRequest, completer: completer));

    if (_isRefreshing) {
      return completer.future;
    }

    _isRefreshing = true;

    try {
      await _refreshToken();

      for (final item in _queue) {
        _retry(item);
      }

      _queue.clear();
      _isRefreshing = false;

      return completer.future;
    } catch (e) {
      for (final item in _queue) {
        item.completer.completeError(e);
      }

      _queue.clear();
      _isRefreshing = false;

      if (e is DioException) {
        final statusCode = e.response?.statusCode;

        if (statusCode == 401 || statusCode == 403) {
          await _logout();
        }
      }

      rethrow;
    }
  }

  // =========================
  // 🔁 RETRY SINGLE REQUEST
  // =========================
  Future<void> _retry(_RetryRequest item) async {
    try {
      final request = item.request;

      final response = await _dio.fetch(request);

      item.completer.complete(response);
    } catch (e) {
      item.completer.completeError(e);
    }
  }

  // =========================
  // 🔑 REFRESH TOKEN
  // =========================
  Future<void> _refreshToken() async {
    final refreshToken = await authLocalDataSource.getRefreshToken();

    final response = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
      options: Options(extra: {'noAuth': true}),
    );

    final newAccessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];

    await authLocalDataSource.saveRefreshToken(newRefreshToken);

    final user = TokenDecoder.decode(newAccessToken);

    sessionManager.saveSessionWithListener(
      accessToken: newAccessToken,
      user: user,
    );
  }

  // =========================
  // 🚪 LOGOUT
  // =========================
  Future<void> _logout() async {
    await authLocalDataSource.clearRefreshToken();
    sessionManager.clearSession();
  }
}

// =========================
// 📦 INTERNAL CLASS
// =========================
class _RetryRequest {
  final RequestOptions request;
  final Completer<Response> completer;

  _RetryRequest({required this.request, required this.completer});
}
