import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/favorite/domain/usecases/add_to_favorites_usecase.dart';
import 'package:zaza_app/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../injection_container.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final NetworkInfo _networkInfo;

  FavoriteBloc(
      this._getFavoritesUseCase, this._addToFavoritesUseCase, this._networkInfo)
      : super(FavoriteState().copyWith(
            favoriteStatus: FavoriteStatus.initial,
            favoriteCurrentIndex: 0,
            isFavoriteLoaded: false,
            favoriteProductsList: [],
            favorites: {},
            isAdded: false,
            scrollController: ScrollController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetFavoriteProducts>(onGetFavoriteProducts);
    on<AddToFavoriteFav>(onAddToFavorite);
    on<ChangeSortFavorite>(onChangeSortFavorite);
  }

  Future<void> _scrollListener() async {
    if (state.favoriteProductsEntity == null) return;

    if (state.scrollController!.position.pixels ==
            state.scrollController!.position.maxScrollExtent &&
        state.favoriteCurrentIndex! + 1 != state.favoritePaginationNumberSave) {
      emit(state.copyWith(
          favoriteCurrentIndex: state.favoriteCurrentIndex! + 1,
          favoriteStatus: FavoriteStatus.paginated));
    }
  }

  @override
  Future<void> close() {
    state.scrollController!.dispose();
    return super.close();
  }

  void onGetFavoriteProducts(
      GetFavoriteProducts event, Emitter<FavoriteState> emit) async {
    if (event.isRefreshAll) {
      List<ProductData> productDiscountList = [];
      emit(state.copyWith(
          isFavoriteLoaded: false,
          favoriteCurrentIndex: event.page,
          favoriteProductsList: productDiscountList));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          favoriteStatus: FavoriteStatus.error,
          isFavoriteLoaded: false));
      return;
    }

    try {
      final favoriteParams = FavoriteParams(
          limit: event.limit,
          page: event.page + 1,
          sort: event.sort,
          search: event.search,
          language: event.language);

      final dataState = await _getFavoritesUseCase(params: favoriteParams);

      if (dataState is DataSuccess) {
        ProductEntity favoriteProductsEntity = dataState.data!;

        int favoritePaginationNumberSave = 1;

        if (favoriteProductsEntity.totalNumber != 1) {
          favoritePaginationNumberSave =
              (favoriteProductsEntity.totalNumber! / event.limit).ceil();
        }

        List<ProductData> favoriteProductsList = event.isRefreshAll ? [] : state.favoriteProductsList!;
        favoriteProductsList.addAll(favoriteProductsEntity.productList!);

        Map<int, bool> favorites = {};
        favoriteProductsList.forEach((element) {
          favorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          favoriteStatus: FavoriteStatus.success,
          favoriteProductsEntity: favoriteProductsEntity,
          favoriteProductsList: favoriteProductsList,
          favoritePaginationNumberSave: favoritePaginationNumberSave,
          favorites: favorites,
          isFavoriteLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            favoriteStatus: FavoriteStatus.error,
            isFavoriteLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          favoriteStatus: FavoriteStatus.error,
          isFavoriteLoaded: false));
    }
  }

  void onAddToFavorite(
      AddToFavoriteFav event, Emitter<FavoriteState> emit) async {
    try {
      emit(state.copyWith(isAdded: false));

      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;

      if (favorites[event.productId]! == false) {
        favorites.removeWhere(
                (key, value) => key == event.productId && value == false);
        state.favoriteProductsList!.removeAt(event.index);
      }

      emit(state.copyWith(
          favoriteProductsList: state.favoriteProductsList,
          favorites: favorites,
          isAdded: true));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {


        emit(state.copyWith(
            favoriteStatus: FavoriteStatus.addedToFavorite,));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            favoriteStatus: FavoriteStatus.errorAddedToFavorite,
            isAdded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          favoriteStatus: FavoriteStatus.errorAddedToFavorite,
          isAdded: false));
    }
  }

  void onChangeSortFavorite(
      ChangeSortFavorite event, Emitter<FavoriteState> emit) async {
    if (sort == 'newest') {
      sort = 'oldest';
    } else {
      sort = 'newest';
    }

    emit(state.copyWith(
        favoriteProductsList: [], favoriteStatus: FavoriteStatus.changeSort));

    // call get favorites
  }
}
