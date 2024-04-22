import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../../../injection_container.dart';
import '../../../../favorite/domain/usecases/add_to_favorites_usecase.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/seacrh_products_usecase.dart';

part 'new_product_event.dart';

part 'new_product_state.dart';

class NewProductBloc extends Bloc<NewProductEvent, NewProductState> {
  final SearchProductsUseCase _searchProductsUseCase;

  final AddToFavoritesUseCase _addToFavoritesUseCase;

  final NetworkInfo _networkInfo;

  NewProductBloc(this._searchProductsUseCase, this._addToFavoritesUseCase,
      this._networkInfo)
      : super(NewProductState().copyWith(
            newProductStatus: NewProductStatus.initial,
            scrollController: ScrollController(),
            isNewProductsLoaded: false,
            newAllProductsList: [],
            newAllProductsFavorites: {},
            newProductsCurrentIndex: 0,isAddedNewProducts: false)) {
      state.scrollController!.addListener(_scrollListener);
      on<GetAllNewProducts>(onGetAllNewProducts);
      on<AddToFavoriteNewProducts>(onAddToFavoriteNewProducts);
      on<ChangeSortNewProducts>(onChangeSortNewProducts);
  }

  Future<void> _scrollListener() async {
    if (state.newAllProductsEntity == null) return;

    if (state.scrollController!.position.pixels ==
            state.scrollController!.position.maxScrollExtent &&
        state.newProductsCurrentIndex! + 1 !=
            state.newProductsPaginationNumberSave) {
      emit(state.copyWith(
          newProductsCurrentIndex: state.newProductsCurrentIndex! + 1,
          newProductStatus: NewProductStatus.loadingAllNewProductsPaginated));
      // call get all new products
    }
  }

  @override
  Future<void> close() {
    state.scrollController!.dispose();
    return super.close();
  }

  void onGetAllNewProducts(
      GetAllNewProducts event, Emitter<NewProductState> emit) async {
    if (event.isRefreshAll) {
      List<ProductData> newAllProductsList = [];
      emit(state.copyWith(
          newProductsCurrentIndex: event.page,
          isNewProductsLoaded: false, newAllProductsList: newAllProductsList));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          newProductStatus: NewProductStatus.errorAllNewProducts, isNewProductsLoaded: false));
      return;
    }

    try {
      final allNewProducts = SearchProductsParams(
          limit: event.limit,
          page: event.page + 1,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState = await _searchProductsUseCase(params: allNewProducts);

      if (dataState is DataSuccess) {
        ProductEntity newProductsEntity = dataState.data!;

        int newPaginationNumberSave = 1;

        if (newProductsEntity.totalNumber != 1) {
          newPaginationNumberSave =
              (newProductsEntity.totalNumber! / event.limit).ceil();
        }

        print('sfdhfhghdfsgaf');
        print( newProductsEntity.productList!.length);

        List<ProductData> newAllProductsList = event.isRefreshAll ? [] : state.newAllProductsList!;
        newAllProductsList.addAll(newProductsEntity.productList!);

        Map<int,bool>favorites = {};
        newAllProductsList.forEach((element) {
          favorites.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          newProductStatus: NewProductStatus.successAllNewProducts,
          newAllProductsEntity: newProductsEntity,
          newAllProductsList: newAllProductsList,
          newProductsPaginationNumberSave: newPaginationNumberSave,
          newAllProductsFavorites: favorites,
          isNewProductsLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            newProductStatus: NewProductStatus.errorAllNewProducts, isNewProductsLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          newProductStatus: NewProductStatus.errorAllNewProducts, isNewProductsLoaded: false));
    }
  }

  void onAddToFavoriteNewProducts(
      AddToFavoriteNewProducts event, Emitter<NewProductState> emit) async {
    try {

      emit(state.copyWith(
        isAddedNewProducts: false,
      ));

      Map<int, bool> favorites = state.newAllProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;

      emit(state.copyWith(
          newAllProductsList: state.newAllProductsList,
          newAllProductsFavorites: favorites,
          isAddedNewProducts: true
      ));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          newProductStatus: NewProductStatus.addedToFavorite,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.newAllProductsFavorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            newProductStatus: NewProductStatus.errorAddedToFavorite,isAddedNewProducts: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.newAllProductsFavorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          newProductStatus: NewProductStatus.errorAddedToFavorite,isAddedNewProducts: false));
    }
  }

  void onChangeSortNewProducts(
      ChangeSortNewProducts event, Emitter<NewProductState> emit) async {
    if (sort == 'newest') {
      sort = 'oldest';
    } else {
      sort = 'newest';
    }

    List<ProductData> newAllProductsList = [];

    emit(state.copyWith(
        newAllProductsList: newAllProductsList, newProductStatus: NewProductStatus.changeSort));

  }
}
