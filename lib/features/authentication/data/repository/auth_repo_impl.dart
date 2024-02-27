import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repo.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _loginApiService;
  AuthRepositoryImpl(this._loginApiService);

  @override
  Future<DataState<UserInfoEntity>> login(String userName, String password) async {
    try {
      final httpResponse = await _loginApiService.login(userName, password);

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

}
