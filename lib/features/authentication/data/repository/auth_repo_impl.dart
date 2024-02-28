import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repo.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<DataState<UserInfoEntity>> login(
      String userName, String password) async {
    try {
      final httpResponse = await _authApiService.login(userName, password);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final UserInfoModel model = httpResponse.data;
        final UserInfoEntity entity = model;
        return DataSuccess(entity);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      print('dsgdfgdg');
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> forgotPassword(String email) async {
    try {
      final httpResponse = await _authApiService.forgotPassword(email);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> validateResetPassword(String email, String token) async {
    try {
      final httpResponse = await _authApiService.validateResetPassword(email, token);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> resetPassword(String email, String token, String password) async {
    try {
      final httpResponse = await _authApiService.resetPassword(email, token, password);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

}
