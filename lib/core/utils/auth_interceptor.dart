import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/core/utils/cache_helper.dart';

import '../../config/config.dart';
import '../../injection_container.dart';
import '../widgets/custom_toast.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Dio dio;

  AuthInterceptor(this.dio);

  bool _isRefreshing = false;
  final _requestsNeedRetry =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response != null &&
        response.statusCode == 401 &&
        response.requestOptions.path != "${baseUrl}/auth/refresh") {
      if (!_isRefreshing) {
        _isRefreshing = true;

        _requestsNeedRetry
            .add((options: response.requestOptions, handler: handler));

        final isRefreshSuccess = await _refreshToken();

        _isRefreshing = false;

        if (isRefreshSuccess) {
          for (var requestNeedRetry in _requestsNeedRetry) {
            final retry = await dio.fetch(requestNeedRetry.options);
            requestNeedRetry.handler.resolve(retry);
          }
          _requestsNeedRetry.clear();
        } else {
          _requestsNeedRetry.clear();
        }
      } else {
        _requestsNeedRetry
            .add((options: response.requestOptions, handler: handler));
      }
    } else {
      return handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Dio refreshTokenDio = Dio(BaseOptions(validateStatus: (statusCode) {
        if (statusCode == 403) {
          return true;
        }
        return true;
      }));
      refreshTokenDio.options.headers["Accept"] = "application/json";
      refreshTokenDio.options.headers["Content-Type"] = "application/json";
      refreshTokenDio.options.headers["Authorization"] =
          'Bearer ${refresh_token}' ?? '';

      final response = await refreshTokenDio.get('${baseUrl}/auth/refresh');
      print(response.statusCode);
      if (response.statusCode == 200) {
        String newAccessToken = response.data['accessToken'];
        String newRefreshToken = response.data['refreshToken'];
        print(response.statusCode);

        debugPrint('refreshing token');

        debugPrint(newAccessToken);
        debugPrint(newRefreshToken);

        await SecureStorage.writeSecureData(
          key: 'refresh-token',
          value: newRefreshToken,
        );

        await SecureStorage.writeSecureData(
          key: 'token',
          value: newAccessToken,
        );
        return true;
      } else {
        print(
            "refresh token fail ${response.statusMessage ?? response.toString()}");
        debugPrint('error refresh token ${response.data['message']}');
        await SecureStorage.deleteAllSecureData();
        showToast(
            text: 'Logout and try to login again', state: ToastState.error);
        return false;
      }
    } catch (exception) {
      print(exception.toString());
      debugPrint('error refresh token');
      await SecureStorage.deleteAllSecureData();
      showToast(text: 'Logout and try to login again', state: ToastState.error);
      return false;
    }
  }
}
