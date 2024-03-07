import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/profile/data/models/user_model.dart';
import 'package:zaza_app/features/profile/domain/entities/user_profile.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repository/profile_repo.dart';
import '../data_sources/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _profileApiService;

  ProfileRepositoryImpl(this._profileApiService);

  @override
  Future<DataState<UserProfileEntity>> getUserProfile(String language) async {
    try {
      final httpResponse = await _profileApiService.getUserProfile(language);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final UserProfileModel model = httpResponse.data;
        final UserProfileEntity entity = model;
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
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createPhoneNumber(
      String language, String data) async {
    try {
      final httpResponse =
          await _profileApiService.createPhoneNumber(language, data);

      if (httpResponse.response.statusCode == HttpStatus.ok || httpResponse.response.statusCode == HttpStatus.created) {
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
  Future<DataState<void>> deletePhoneNumber(
      int phoneId, String language) async {
    try {
      final httpResponse =
          await _profileApiService.deletePhoneNumber(phoneId, language);

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
