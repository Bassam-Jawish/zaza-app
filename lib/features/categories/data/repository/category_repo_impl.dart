import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/features/categories/domain/entities/choose_type_entity.dart';
import 'package:zaza_app/features/categories/domain/repository/category_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../data_sources/category_api_service.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService _categoryApiService;

  CategoryRepositoryImpl(
    this._categoryApiService,
  );

  @override
  Future<DataState<dynamic>> getCategoryChildren(
      dynamic id, int limit, int page, dynamic language) async {
    try {
      final httpResponse = await _categoryApiService.getCategoryChildren(
          id, limit, page, language);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final dynamic model = httpResponse.data;
        final dynamic entity = model;
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
}
