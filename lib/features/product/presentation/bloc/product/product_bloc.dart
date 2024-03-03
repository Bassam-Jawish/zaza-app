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
import '../../../../favorite/domain/usecases/add_to_favorites_usecase.dart';
import '../../../domain/usecases/get_product_info_usecase.dart';
import '../../../domain/usecases/seacrh_products_usecase.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SearchProductsUseCase _searchProductsUseCase;

  final GetProductInfoUseCase _getProductInfoUseCase;

  final AddToFavoritesUseCase _addToFavoritesUseCase;

  final NetworkInfo _networkInfo;

  ProductBloc(this._searchProductsUseCase, this._getProductInfoUseCase,
      this._addToFavoritesUseCase, this._networkInfo)
      : super(ProductState().copyWith(
            productStatus: ProductStatus.initial,
            newHomeProductsFavorites: {},
            searchBarcodeProductsFavorites: {},
            searchNameProductsFavorites: {},
            isNewHomeLoaded: false,
            isProductProfileLoaded: false,
            isSearchByBarcodeLoaded: false,
            isSearchByNameLoaded: false)) {
    on<ProductEvent>((event, emit) async {
      if (event is GetHomeNewProducts) await onGetHomeNewProducts(event, emit);
      if (event is GetSearchBarcodeProducts)
        await onGetSearchBarcodeProducts(event, emit);
      if (event is GetSearchNameProducts)
        await onGetSearchNameProducts(event, emit);
      if (event is GetProductProfile) await onGetProductProfile(event, emit);
      if (event is ChangeUnitIndex) onChangeUnitIndex(event, emit);
      if (event is ScanBarcode) await onScanBarcode(event, emit);
      if (event is AddToFavoriteSearchByBarCode)
        await onAddToFavoriteSearchByBarCode(event, emit);
      if (event is AddToFavoriteSearchByName)
        await onAddToFavoriteSearchByName(event, emit);
      if (event is AddToFavoriteHomeNewProducts)
        await onAddToFavoriteHomeNewProducts(event, emit);
    });
  }

  Future<void> onGetHomeNewProducts(
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
          page: event.page + 1,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        dataState.data!.productList!.forEach((element) {
          state.newHomeProductsFavorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          homeNewProductsEntity: dataState.data,
          productStatus: ProductStatus.successHomeNewProducts,
          newHomeProductsFavorites: state.newHomeProductsFavorites,
          isNewHomeLoaded: true,
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

  Future<void> onGetSearchBarcodeProducts(
      GetSearchBarcodeProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
        productStatus: ProductStatus.loadingBarcodeSearch,
        isSearchByBarcodeLoaded: false));

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
          page: event.page + 1,
          sort: event.sort,
          search: 'barCode:${event.search}',
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          searchBarcodeProductsEntity: dataState.data,
          productStatus: ProductStatus.successBarcodeSearch,
          isSearchByBarcodeLoaded: true,
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

  Future<void> onGetSearchNameProducts(
      GetSearchNameProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
        productStatus: ProductStatus.loadingNameSearch,
        isSearchByNameLoaded: false));

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
          page: event.page + 1,
          sort: event.sort,
          search: 'name:${event.search}',
          language: event.language);

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          searchNameProductsEntity: dataState.data,
          productStatus: ProductStatus.successNameSearch,
          isSearchByNameLoaded: true,
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

  Future<void> onGetProductProfile(
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
            isProductProfileLoaded: true));
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

  Future<void> onScanBarcode(ScanBarcode event, Emitter<ProductState> emit) async {
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

  Future<void> onAddToFavoriteHomeNewProducts(
      AddToFavoriteHomeNewProducts event, Emitter<ProductState> emit) async {
    try {
      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.newHomeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere(
              (key, value) => key == event.productId && value == false);
          state.homeNewProductsEntity!.productList!.removeAt(event.index);
        }

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteNewProducts,
          homeNewProductsEntity: state.homeNewProductsEntity,
          newHomeProductsFavorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.newHomeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorAddedToFavoriteNewProducts));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.newHomeProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorAddedToFavoriteNewProducts));
    }
  }

  Future<void> onAddToFavoriteSearchByBarCode(
      AddToFavoriteSearchByBarCode event, Emitter<ProductState> emit) async {
    try {
      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere(
              (key, value) => key == event.productId && value == false);
          state.searchBarcodeProductsEntity!.productList!.removeAt(event.index);
        }

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteSearchByBarcode,
          searchBarcodeProductsEntity: state.searchBarcodeProductsEntity,
          searchBarcodeProductsFavorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorAddedToFavoriteSearchByBarcode));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorAddedToFavoriteSearchByBarcode));
    }
  }

  Future<void> onAddToFavoriteSearchByName(
      AddToFavoriteSearchByName event, Emitter<ProductState> emit) async {
    try {
      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.searchNameProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere(
              (key, value) => key == event.productId && value == false);
          state.searchNameProductsEntity!.productList!.removeAt(event.index);
        }

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteSearchByName,
          searchNameProductsEntity: state.searchNameProductsEntity,
          searchNameProductsFavorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.searchNameProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorAddedToFavoriteSearchByName));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.searchNameProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorAddedToFavoriteSearchByName));
    }
  }
}
