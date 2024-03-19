import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/utils/cache_helper.dart';

import '../../config/config.dart';
import '../../config/routes/app_router.dart';
import '../../injection_container.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path == '/auth/refresh') {
      debugPrint('logout');
      await SecureStorage.deleteAllSecureData();
      final router = AppRouter.router;
      router.pushReplacement(AppRouter.kOnboardingPage);
    } else if (err.response?.statusCode == 401 && refresh_token != 'No data found!') {
      final success = await refreshToken();
      if (success != null) {
        dio.options.headers['authorization'] = 'Bearer $token';
          return handler.resolve(await dio.fetch(err.requestOptions));
      }
    }
    return handler.next(err);
  }

  Future refreshToken() async {
    debugPrint('call function');
    Dio refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    refreshDio.options.headers["Accept"] = "application/json";
    refreshDio.options.headers["Content-Type"] = "application/json";
    refreshDio.options.headers["Authorization"] =
        'Bearer ${refresh_token}' ?? '';

    try {
      var response = await refreshDio.get(
        '${baseUrl}/auth/refresh',
      );

      if (response.statusCode == 200) {
        // Handle successful token refresh
        String newAccessToken = response.data['accessToken'];
        String newRefreshToken = response.data['refreshToken'];

        debugPrint('refreshing token');
        debugPrint(newAccessToken);
        debugPrint(newRefreshToken);

        refresh_token = newRefreshToken;
        await SecureStorage.writeSecureData(
          key: 'refresh_token',
          value: newRefreshToken,
        );
        token = newAccessToken;
        await SecureStorage.writeSecureData(
          key: 'token',
          value: newAccessToken,
        );
        return true;
      } else {
        debugPrint('logout');
        await SecureStorage.deleteAllSecureData();
        final router = AppRouter.router;
        router.pushReplacement(AppRouter.kOnboardingPage);
      }
    } on DioException catch (dioError) {
      debugPrint('logout');
      await SecureStorage.deleteAllSecureData();
      final router = AppRouter.router;
      router.pushReplacement(AppRouter.kOnboardingPage);
    }
  }
}
