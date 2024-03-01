import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/orders/domain/entities/order.dart';
import 'package:zaza_app/features/orders/domain/entities/order_details.dart';
import 'package:zaza_app/features/orders/domain/usecases/get_order_details_usecase.dart';
import 'package:zaza_app/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase _getOrdersUseCase;

  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final NetworkInfo _networkInfo;

  OrderBloc(
      this._getOrdersUseCase, this._getOrderDetailsUseCase, this._networkInfo)
      : super(OrderState().copyWith(
            orderStatus: OrderStatus.initial,
            statusSearch: 'all',
            ordersList: [])) {
    on<OrderEvent>((event, emit) {
      on<GetOrders>(onGetOrders);
      on<GetOrderDetails>(onGetOrderDetails);
      on<ChangeDropdownValue>(onChangeDropdownValue);
    });
  }

  void onGetOrders(GetOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(orderStatus: OrderStatus.loading));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          orderStatus: OrderStatus.error));
      return;
    }

    try {
      final orderParams = OrderParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          status: event.status);

      final dataState = await _getOrdersUseCase(params: orderParams);

      GeneralOrdersEntity generalOrdersEntity = dataState.data!;

      state.ordersList!.addAll(generalOrdersEntity.ordersList!);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          ordersList: state.ordersList,
          generalOrdersEntity: generalOrdersEntity,
          orderStatus: OrderStatus.success,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            orderStatus: OrderStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          orderStatus: OrderStatus.error));
    }
  }

  void onGetOrderDetails(
      GetOrderDetails event, Emitter<OrderState> emit) async {
    emit(state.copyWith(orderStatus: OrderStatus.loadingOrder));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          orderStatus: OrderStatus.errorOrder));
      return;
    }

    try {
      final orderDetailsParams =
          OrderDetailsParams(orderId: event.orderId, language: languageCode);

      final dataState =
          await _getOrderDetailsUseCase(params: orderDetailsParams);

      OrderDetailsEntity orderDetailsEntity = dataState.data!;

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          ordersList: state.ordersList,
          orderDetailsEntity: orderDetailsEntity,
          orderStatus: OrderStatus.successOrder,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            orderStatus: OrderStatus.errorOrder));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          orderStatus: OrderStatus.errorOrder));
    }
  }

  void onChangeDropdownValue(
      ChangeDropdownValue event, Emitter<OrderState> emit) async {

    emit(state.copyWith(statusSearch: event.val,orderStatus: OrderStatus.changeStatusSearch));
    // call get Orders

  }
}