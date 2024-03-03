import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';

import '../../domain/repository/product_repo.dart';
import '../data_sources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _productApiService;

  ProductRepositoryImpl(this._productApiService);

  @override
  Future<DataState<ProductData>> getProductInfo(
      int productId, dynamic language) async {
    try {
      final httpResponse =
          await _productApiService.getProductInfo(productId, language);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final ProductDataModel model = httpResponse.data;
        final ProductData entity = model;
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
  Future<DataState<ProductEntity>> searchProducts(
      int limit, int page, String sort, String search, dynamic language) async {
    try {
      final httpResponse =
          await _productApiService.search(limit, page, sort, search, language);

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
}
