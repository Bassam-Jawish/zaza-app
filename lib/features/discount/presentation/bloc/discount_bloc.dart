import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/discount/domain/usecases/get_discount_usecase.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../product/domain/entities/product.dart';

part 'discount_event.dart';

part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final GetDiscountUseCase _getDiscountUseCase;
  final NetworkInfo _networkInfo;

  DiscountBloc(this._getDiscountUseCase, this._networkInfo)
      : super(
            DiscountState().copyWith(discountStatus: DiscountStatus.initial)) {

    on<GetDiscountProducts>(onGetDiscountProducts);
  }

  void onGetDiscountProducts(
      GetDiscountProducts event, Emitter<DiscountState> emit) async {
    emit(state.copyWith(discountStatus: DiscountStatus.loading));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          discountStatus: DiscountStatus.error));
      return;
    }

    try {
      final discountParams = DiscountParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          language: event.language);

      final dataState = await _getDiscountUseCase(params: discountParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
            productEntity: dataState.data,
            discountStatus: DiscountStatus.success,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            discountStatus: DiscountStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          discountStatus: DiscountStatus.error));
    }
  }
}
