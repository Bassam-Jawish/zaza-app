import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repository/favorite_repo.dart';
import '../data_sources/favorite_api_service.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteApiService _favoriteApiService;

  FavoriteRepositoryImpl(
      this._favoriteApiService);

  @override
  Future<DataState<ProductEntity>> getFavoriteProducts(
      int limit, int page, String sort, String search, String status) async {
    try {
      final httpResponse = await _favoriteApiService.getFavoriteProducts(limit, page, sort, search, status);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final ProductModel model = httpResponse.data;
        final ProductEntity entity = model;
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
  Future<DataState<void>> addToFavorite(
      int productId) async {
    try {
      final httpResponse = await _favoriteApiService.addToFavorite(productId);
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
