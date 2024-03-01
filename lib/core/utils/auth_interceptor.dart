import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/core/utils/cache_helper.dart';

import '../../config/config.dart';
import '../../injection_container.dart';
import '../widgets/custom_toast.dart';
/*
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

  int g = 0;
  Future<bool> _refreshToken() async {
    try {
      print(g);
      g++;
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
*/

class RefreshTokenInterceptor extends Interceptor {
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;
  RefreshTokenInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If refresh token is not available, perform logout
      if ((refresh_token ?? "").isEmpty) {
        // ... (Logout logic)
        return handler.reject(err);
      }
      if (!isRefreshing) {
        // Initiating token refresh
        isRefreshing = true;
        final bool success = await refreshToken(err, handler);
        if (success) {
          // ... (Update headers and retry logic)
          err.requestOptions.headers['Authorization'] = 'Bearer ${token}';
        } else {
          // If the refresh process fails, reject with the previous error
          return handler.next(err);
        }
      } else {
        // Adding errored request to the queue
        failedRequests.add({'err': err, 'handler': handler});
      }
    } else {
      return handler.next(err);
    }
  }

  Future refreshToken(DioException err, ErrorInterceptorHandler handler) async {
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
    // handle refresh token
    retryDio.options.headers["Accept"] = "application/json";
    retryDio.options.headers["Content-Type"] = "application/json";
    retryDio.options.headers["Authorization"] = 'Bearer ${refresh_token}' ?? '';

    var response = await retryDio.get(
      '${baseUrl}/auth/refresh',
    );
    if (response.statusCode == 401 || response.statusCode == 403) {
      // handle logout
      debugPrint('logout');
    }
    if (response.statusCode == 200) {
      //save new refresh token and acces token
      String newAccessToken = response.data['accessToken'];
      String newRefreshToken = response.data['refreshToken'];
      print(response.statusCode);

      debugPrint('refreshing token');

      debugPrint(newAccessToken);
      debugPrint(newRefreshToken);

      refresh_token = newRefreshToken;
      await SecureStorage.writeSecureData(
        key: 'refresh-token',
        value: newRefreshToken,
      );
      token = newAccessToken;
      await SecureStorage.writeSecureData(
        key: 'token',
        value: newAccessToken,
      );
      failedRequests.add({'err': err, 'handler': handler});
      await retryRequests(token);
      return true;
    } else {
      isRefreshing = false;
      debugPrint('logout');
    }
  }

  Future retryRequests(
    token,
  ) async {
    // Create a Dio instance for retrying requests
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
    // Iterate through failed requests and retry them
    for (var i = 0; i < failedRequests.length; i++) {
      // Get the RequestOptions from the failed request
      RequestOptions requestOptions =
          failedRequests[i]['err'].requestOptions as RequestOptions;

      // Update headers with the new access token
      requestOptions.headers = {
        'Authorization': 'Bearer $token',
      };

      // Retry the request using the new token
      await retryDio.fetch(requestOptions).then(
        failedRequests[i]['handler'].resolve,
        onError: (error) async {
          // Reject the request if an error occurs during retry
          failedRequests[i]['handler'].reject(error as DioError);
        },
      );
    }
    // Reset the refreshing state and clear the failed requests queue
    isRefreshing = false;
    failedRequests = [];
  }
}
