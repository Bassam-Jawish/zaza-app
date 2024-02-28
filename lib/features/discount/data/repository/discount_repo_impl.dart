
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repository/discount_repo.dart';
import '../data_sources/discount_api_service.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  final DiscountApiService _discountApiService;

  DiscountRepositoryImpl(
      this._discountApiService);

  @override
  Future<DataState<ProductEntity>> getDiscountProducts(
      int limit, int page, String sort, dynamic language) async {
    try {
      final httpResponse = await _discountApiService.getDiscountProducts(limit, page, sort, language);

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
