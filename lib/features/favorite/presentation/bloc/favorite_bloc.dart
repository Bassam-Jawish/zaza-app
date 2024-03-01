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
            isFirst: true,
            favoriteProductsList: [],
            favorites: {},
            scrollController: ScrollController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetFavoriteProducts>(onGetFavoriteProducts);
    on<AddToFavorite>(onAddToFavorite);
    on<ChangeSort>(onChangeSort);
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
    if (state.isFirst!) {
      emit(state.copyWith(isFirst: false, favoriteCurrentIndex: event.page));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          favoriteStatus: FavoriteStatus.error));
      return;
    }

    try {
      final favoriteParams = FavoriteParams(
          limit: event.limit,
          page: event.page,
          sort: event.sort,
          search: event.search,
          status: event.status);

      final dataState = await _getFavoritesUseCase(params: favoriteParams);

      if (dataState is DataSuccess) {
        ProductEntity favoriteProductsEntity = dataState.data!;

        int favoritePaginationNumberSave = 1;

        if (favoriteProductsEntity.totalNumber != 1) {
          favoritePaginationNumberSave =
              (favoriteProductsEntity.totalNumber! / event.limit).ceil();
        }

        state.favoriteProductsList!.addAll(favoriteProductsEntity.productList!);

        state.favoriteProductsList!.forEach((element) {
          state.favorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          favoriteStatus: FavoriteStatus.success,
          favoriteProductsEntity: favoriteProductsEntity,
          favoriteProductsList: state.favoriteProductsList,
          favoritePaginationNumberSave: favoritePaginationNumberSave,
          favorites: state.favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            favoriteStatus: FavoriteStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          favoriteStatus: FavoriteStatus.error));
    }
  }

  void onAddToFavorite(
      AddToFavorite event, Emitter<FavoriteState> emit) async {

    try {
      final addToFavoriteParams = AddToFavoriteParams(productId: event.productId,);

      final dataState = await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {

        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere((key, value) => key == event.productId && value == false);
          state.favoriteProductsList!.removeAt(event.index);
        }

        emit(state.copyWith(
          favoriteStatus: FavoriteStatus.addedToFavorite,
          favoriteProductsList: state.favoriteProductsList,
          favorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            favoriteStatus: FavoriteStatus.errorAddedToFavorite));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          favoriteStatus: FavoriteStatus.errorAddedToFavorite));
    }

  }


  void onChangeSort(
      ChangeSort event, Emitter<FavoriteState> emit) async {

    if (sort == 'newest') {
      sort = 'oldest';
    }
    else {
      sort = 'newest';
    }

    emit(state.copyWith(favoriteProductsList: [], favoriteStatus: FavoriteStatus.changeSort));

    // call get favorites

  }
}
