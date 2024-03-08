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
import '../../../../../injection_container.dart';
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
            isAddedSearchByBarcode: false,
            isAddedSearchByName: false,
            isFirstSearchName: false,
            isSearchByNameLoaded: false,
            unitIndex: 0,
            isFirstSearchBarcode: false,
            searchBarcodeCurrentIndex: 0,
            searchNameCurrentIndex: 0,
            productSearchNameList: [],
            productSearchBarcodeList: [],
            scrollControllerSearchBarcode: ScrollController(),
            scrollControllerSearchName: ScrollController(),
            isAddedHomeNewProducts: false)) {
    on<ProductEvent>((event, emit) async {
      state.scrollControllerSearchBarcode!.addListener(_scrollListener1);
      state.scrollControllerSearchName!.addListener(_scrollListener2);
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

  Future<void> _scrollListener1() async {
    if (state.searchBarcodeProductsEntity == null) return;

    if (state.scrollControllerSearchBarcode!.position.pixels ==
            state.scrollControllerSearchBarcode!.position.maxScrollExtent &&
        state.searchBarcodeCurrentIndex! + 1 !=
            state.searchBarcodePaginationNumberSave) {
      emit(state.copyWith(
          searchBarcodeCurrentIndex: state.searchBarcodeCurrentIndex! + 1,
          productStatus: ProductStatus.loadingBarcodeSearchPaginated));
      // call get all search Barcode
    }
  }

  Future<void> _scrollListener2() async {
    if (state.searchNameProductsEntity == null) return;

    if (state.scrollControllerSearchName!.position.pixels ==
            state.scrollControllerSearchName!.position.maxScrollExtent &&
        state.searchNameCurrentIndex! + 1 !=
            state.searchNamePaginationNumberSave) {
      emit(state.copyWith(
          searchNameCurrentIndex: state.searchNameCurrentIndex! + 1,
          productStatus: ProductStatus.loadingNameSearchPaginated));
      // call get search Name
    }
  }

  @override
  Future<void> close() {
    state.scrollControllerSearchBarcode!.dispose();
    state.scrollControllerSearchName!.dispose();
    return super.close();
  }

  Future<void> onGetHomeNewProducts(
      GetHomeNewProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      productStatus: ProductStatus.loadingHomeNewProducts,
      isNewHomeLoaded: false,
    ));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          productStatus: ProductStatus.errorHomeNewProducts,
          isAddedSearchByBarcode: false));
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
        List<ProductData> productList = dataState.data!.productList!;
        Map<int, bool> newHomeProductsFavorites = {};
        productList.forEach((element) {
          newHomeProductsFavorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          homeNewProductsEntity: dataState.data,
          productStatus: ProductStatus.successHomeNewProducts,
          newHomeProductsFavorites: newHomeProductsFavorites,
          isNewHomeLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorHomeNewProducts,
            isNewHomeLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorHomeNewProducts,
          isNewHomeLoaded: false));
    }
  }

  Future<void> onGetSearchBarcodeProducts(
      GetSearchBarcodeProducts event, Emitter<ProductState> emit) async {
    if (event.onRefreshAll) {
      List<ProductData> productBarcodeList = [];
      emit(state.copyWith(
          searchBarcodeCurrentIndex: event.page,
          isSearchByBarcodeLoaded: false,
          isFirstSearchBarcode: true,
          productSearchBarcodeList: productBarcodeList));
    }

    barcodeSearch = event.search;

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
        ProductEntity searchBarcodeProductsEntity = dataState.data!;

        int searchBarcodePaginationNumberSave = 1;

        if (searchBarcodeProductsEntity.totalNumber != 1) {
          searchBarcodePaginationNumberSave =
              (searchBarcodeProductsEntity.totalNumber! / event.limit).ceil();
        }

        List<ProductData> productSearchBarcodeList =
            state.productSearchBarcodeList!;
        productSearchBarcodeList!
            .addAll(searchBarcodeProductsEntity.productList!);

        Map<int, bool> favorites = {};
        productSearchBarcodeList.forEach((element) {
          favorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          productStatus: ProductStatus.successBarcodeSearch,
          searchBarcodeProductsEntity: searchBarcodeProductsEntity,
          productSearchBarcodeList: productSearchBarcodeList,
          searchBarcodePaginationNumberSave: searchBarcodePaginationNumberSave,
          searchBarcodeProductsFavorites: favorites,
          isAddedSearchByBarcode: true,
          isFirstSearchBarcode: true,
          isSearchByBarcodeLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(
              dataState.error!,
            ),
            productStatus: ProductStatus.errorBarcodeSearch,
            isAddedSearchByBarcode: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorBarcodeSearch,
          isAddedSearchByBarcode: false));
    }
  }

  Future<void> onGetSearchNameProducts(
      GetSearchNameProducts event, Emitter<ProductState> emit) async {
    if (event.onRefreshAll) {
      List<ProductData> productNameList = [];
      emit(state.copyWith(
        searchNameCurrentIndex: event.page,
        isSearchByNameLoaded: false,
        isFirstSearchName: true,
        productSearchNameList: productNameList,
      ));
    }

    nameSearch = event.search;

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        error: ConnectionFailure('No Internet Connection'),
        productStatus: ProductStatus.errorNameSearch,
      ));
      return;
    }

    try {
      final searchProductsParams = SearchProductsParams(
        limit: event.limit,
        page: event.page + 1,
        sort: event.sort,
        search: 'name:${event.search}',
        language: event.language,
      );

      final dataState =
          await _searchProductsUseCase(params: searchProductsParams);

      if (dataState is DataSuccess) {
        ProductEntity searchNameProductsEntity = dataState.data!;

        int searchNamePaginationNumberSave = 1;

        if (searchNameProductsEntity.totalNumber != 1) {
          searchNamePaginationNumberSave =
              (searchNameProductsEntity.totalNumber! / event.limit).ceil();
        }

        List<ProductData> productSearchNameList = state.productSearchNameList!;
        productSearchNameList.addAll(searchNameProductsEntity.productList!);

        Map<int, bool> favorites = {};
        productSearchNameList.forEach((element) {
          favorites.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          productStatus: ProductStatus.successNameSearch,
          searchNameProductsEntity: searchNameProductsEntity,
          productSearchNameList: productSearchNameList,
          searchNamePaginationNumberSave: searchNamePaginationNumberSave,
          searchNameProductsFavorites: favorites,
          isAddedSearchByName: true,
          isFirstSearchName: true,
          isSearchByNameLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
          error: ServerFailure.fromDioError(dataState.error!),
          productStatus: ProductStatus.errorNameSearch,
          isAddedSearchByName: false,
        ));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        error: ServerFailure.fromDioError(e),
        productStatus: ProductStatus.errorNameSearch,
        isAddedSearchByName: false,
      ));
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

  Future<void> onScanBarcode(
      ScanBarcode event, Emitter<ProductState> emit) async {
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
      emit(state.copyWith(
        isAddedHomeNewProducts: false,
      ));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.newHomeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteNewProducts,
          homeNewProductsEntity: state.homeNewProductsEntity,
          newHomeProductsFavorites: favorites,
          isAddedHomeNewProducts: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.newHomeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
          error: ServerFailure.fromDioError(dataState.error!),
          productStatus: ProductStatus.errorAddedToFavoriteNewProducts,
          isAddedHomeNewProducts: false,
        ));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.newHomeProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
        error: ServerFailure.fromDioError(e),
        productStatus: ProductStatus.errorAddedToFavoriteNewProducts,
        isAddedHomeNewProducts: false,
      ));
    }
  }

  Future<void> onAddToFavoriteSearchByBarCode(
      AddToFavoriteSearchByBarCode event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(isAddedSearchByBarcode: false));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteSearchByBarcode,
          searchBarcodeProductsEntity: state.searchBarcodeProductsEntity,
          searchBarcodeProductsFavorites: favorites,
          isAddedSearchByBarcode: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorAddedToFavoriteSearchByBarcode,
            isAddedSearchByBarcode: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.searchBarcodeProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorAddedToFavoriteSearchByBarcode,
          isAddedSearchByBarcode: false));
    }
  }

  Future<void> onAddToFavoriteSearchByName(
      AddToFavoriteSearchByName event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(isAddedSearchByName: false));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.searchNameProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        emit(state.copyWith(
          productStatus: ProductStatus.addedToFavoriteSearchByName,
          searchNameProductsEntity: state.searchNameProductsEntity,
          searchNameProductsFavorites: favorites,
          isAddedSearchByName: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.searchNameProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            productStatus: ProductStatus.errorAddedToFavoriteSearchByName,
            isAddedSearchByName: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.searchNameProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          productStatus: ProductStatus.errorAddedToFavoriteSearchByName,
          isAddedSearchByName: false));
    }
  }
}
