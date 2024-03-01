import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zaza_app/features/orders/data/models/order_details_model.dart';
import 'package:zaza_app/features/orders/data/models/order_model.dart';
import 'package:zaza_app/features/orders/domain/entities/order.dart';
import 'package:zaza_app/features/orders/domain/entities/order_details.dart';

import '../../../../core/resources/data_state.dart';
import '../../../basket/data/models/product_unit.dart';
import '../../domain/repository/order_repo.dart';
import '../data_sources/order_api_service.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderApiService _orderApiService;

  OrderRepositoryImpl(this._orderApiService);

  @override
  Future<DataState<GeneralOrdersEntity>> getOrders(
      int limit, int page, String sort, String status) async {
    try {
      final httpResponse =
          await _orderApiService.getOrders(limit, page, sort, status);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final GeneralOrdersModel model = httpResponse.data;
        final GeneralOrdersEntity entity = model;
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
  Future<DataState<OrderDetailsEntity>> getOrderDetails(
      int orderId, dynamic language) async {
    try {
      final httpResponse =
          await _orderApiService.getOrderDetails(orderId, language);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final OrderDetailsModel model = httpResponse.data;
        final OrderDetailsEntity entity = model;
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
