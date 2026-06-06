import 'dart:async';

import 'package:dio/dio.dart';
import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/core/session/session_manager.dart';
import 'package:CivicPulse/device_info.dart';
import 'package:CivicPulse/features/auth/data/dataSources/auth_local_datasource.dart';
import 'package:CivicPulse/features/auth/data/utils/token_decoder.dart';

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

    // ✅ Skip refresh for unauthenticated endpoints (login, signup, refresh)
    final noAuth = options.extra['noAuth'] == true;
    if (noAuth) {
      return handler.next(err);
    }

    // ❌ refresh endpoint failed → logout
    if (options.path.contains('/auth/refresh')) {
      if (statusCode == 401 || statusCode == 403 || statusCode == 400) {
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

        if (statusCode == 401 || statusCode == 403 || statusCode == 400) {
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

      if (sessionManager.accessToken != null) {
        request.headers['Authorization'] = 'Bearer ${sessionManager.accessToken}';
      }

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
    final refreshToken = sessionManager.refreshToken ?? await authLocalDataSource.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _logout();
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        error: 'Missing refresh token',
      );
    }
    final response = await _dio.post(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
        'clientType': DeviceInfo.getDevicePlatform(),
      },
      options: Options(extra: {'noAuth': true}),
    );

    final newAccessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];

    await authLocalDataSource.saveRefreshToken(newRefreshToken);

    final user = TokenDecoder.decode(newAccessToken);

    sessionManager.saveSessionWithListener(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
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
