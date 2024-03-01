import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/usecases/get_product_info_usecase.dart';
import '../../../domain/usecases/seacrh_products_usecase.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SearchProductsUseCase _searchProductsUseCase;

  final GetProductInfoUseCase _getProductInfoUseCase;

  final NetworkInfo _networkInfo;

  ProductBloc(this._searchProductsUseCase, this._getProductInfoUseCase,
      this._networkInfo)
      : super(ProductState().copyWith(productStatus: ProductStatus.initial)) {
    on<ProductEvent>((event, emit) {
      on<GetHomeNewProducts>(onGetHomeNewProducts);
      on<GetSearchBarcodeProducts>(onGetSearchBarcodeProducts);
      on<GetSearchNameProducts>(onGetSearchNameProducts);
      on<GetProductProfile>(onGetProductProfile);
      on<ChangeUnitIndex>(onChangeUnitIndex);
      on<ScanBarcode>(onScanBarcode);
    });
  }

  void onGetHomeNewProducts(
      GetHomeNewProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(productStatus: ProductStatus.loadingHomeNewProducts));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          productStatus: ProductStatus.errorHomeNewProducts));
      return;
    }

    try {
      final searchProductsParams = SearchProductsParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          homeNewProductsEntity: dataState.data,
          productStatus: ProductStatus.successHomeNewProducts,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorHomeNewProducts));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorHomeNewProducts));
    }
  }

  void onGetSearchBarcodeProducts(
      GetSearchBarcodeProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(productStatus: ProductStatus.loadingBarcodeSearch));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          productStatus: ProductStatus.errorBarcodeSearch));
      return;
    }

    try {
      final searchProductsParams = SearchProductsParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          searchBarcodeProductsEntity: dataState.data,
          productStatus: ProductStatus.successBarcodeSearch,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorBarcodeSearch));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorBarcodeSearch));
    }
  }

  void onGetSearchNameProducts(
      GetSearchNameProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(productStatus: ProductStatus.loadingNameSearch));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          productStatus: ProductStatus.errorNameSearch));
      return;
    }

    try {
      final searchProductsParams = SearchProductsParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          searchNameProductsEntity: dataState.data,
          productStatus: ProductStatus.successNameSearch,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorNameSearch));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorNameSearch));
    }
  }

  void onGetProductProfile(
      GetProductProfile event, Emitter<ProductState> emit) async {
    emit(state.copyWith(productStatus: ProductStatus.loadingProductProfile));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          productStatus: ProductStatus.errorProductProfile));
      return;
    }

    try {
      final productInfoParams = ProductInfoParams(
          productId: event.productId, language: event.language);

      final dataState = await _getProductInfoUseCase(params: productInfoParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          productProfile: dataState.data,
          productStatus: ProductStatus.successProductProfile,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorProductProfile));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorProductProfile));
    }
  }

  void onChangeUnitIndex(
      ChangeUnitIndex event, Emitter<ProductState> emit) async {
    int unitIndex = state!.productProfile!.productUnitListModel!
        .indexOf(state.productProfile!.productUnitListModel![event.index]);
    emit(state.copyWith(
      unitIndex: unitIndex,
      productStatus: ProductStatus.changeUnitIndex,
    ));
  }

  void onScanBarcode(ScanBarcode event, Emitter<ProductState> emit) async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to get platform version';
    }

    emit(state.copyWith(
        scanBarcode: scanResult, productStatus: ProductStatus.scannedBarcode));
  }
}
