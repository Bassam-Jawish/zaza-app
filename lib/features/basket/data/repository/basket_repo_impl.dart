import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repository/basket_repo.dart';
import '../data_sources/local/basket_database_service.dart';
import '../data_sources/remote/basket_api_service.dart';

class BasketRepositoryImpl implements BasketRepository {
  final BasketApiService _basketApiService;

  final BasketLocalDatabaseService _basketLocalDatabaseService;

  BasketRepositoryImpl(
      this._basketApiService, this._basketLocalDatabaseService);

  @override
  Future<DataState<ProductEntity>> getBasketProducts(
      int limit, int page, dynamic language, List<dynamic> idList) async {
    try {
      final httpResponse = await _basketApiService.getBasketProducts(
          limit, page, language, idList);

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
  Future<DataState<void>> getIdQuantityForBasket() async {
    try {
      final getIdQuantityForBasket =
          await _basketLocalDatabaseService.getIdQuantityForBasket();
      return DataSuccess(getIdQuantityForBasket);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> addToBasket(int product_unit_id, int quantity) async {
    try {
      final addToBasket = await _basketLocalDatabaseService
          .addToBasket(product_unit_id: product_unit_id, quantity: quantity);
      return DataSuccess(addToBasket);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> editQuantityBasket(int product_unit_id, int quantity, int index) async {
    try {
      final editQuantityBasket = await _basketLocalDatabaseService
          .editQuantityBasket(product_unit_id: product_unit_id, quantity: quantity, index: index);
      return DataSuccess(editQuantityBasket);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> removeOneFromBasket(int index) async {
    try {
      final removeOneFromBasket = await _basketLocalDatabaseService
          .removeOneFromBasket(index: index);
      return DataSuccess(removeOneFromBasket);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteBasket() async {
    try {
      final deleteBasket = await _basketLocalDatabaseService
          .deleteBasket();
      return DataSuccess(deleteBasket);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
