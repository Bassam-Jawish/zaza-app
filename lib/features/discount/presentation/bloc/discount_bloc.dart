import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/discount/domain/usecases/get_discount_usecase.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../injection_container.dart';
import '../../../favorite/domain/usecases/add_to_favorites_usecase.dart';
import '../../../product/domain/entities/product.dart';

part 'discount_event.dart';

part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final GetDiscountUseCase _getDiscountUseCase;

  final AddToFavoritesUseCase _addToFavoritesUseCase;

  final NetworkInfo _networkInfo;

  DiscountBloc(
      this._getDiscountUseCase, this._addToFavoritesUseCase, this._networkInfo)
      : super(DiscountState().copyWith(
            discountStatus: DiscountStatus.initial,
            discountCurrentIndex: 0,
            favorites: {},
            isFirstDiscount: true,
            scrollController: ScrollController(),
            productDiscountList: [],isDiscountHomeLoaded: false)) {
    on<DiscountEvent>((event, emit) async {
      state.scrollController!.addListener(_scrollListener);
      if (event is GetHomeDiscountProducts) await onGetHomeDiscountProducts(event, emit);
      if (event is GetAllDiscountProducts) await onGetAllDiscountProducts(event, emit);
      if (event is AddToFavoriteDiscount) await onAddToFavoriteDiscount(event, emit);
      if (event is ChangeSortDiscount) onChangeSortDiscount(event, emit);
    });
  }
  Future<void> _scrollListener() async {
    if (state.productAllDiscountEntity == null) return;

    if (state.scrollController!.position.pixels ==
            state.scrollController!.position.maxScrollExtent &&
        state.discountCurrentIndex! + 1 != state.discountPaginationNumberSave) {
      emit(state.copyWith(
          discountCurrentIndex: state.discountCurrentIndex! + 1,
          discountStatus: DiscountStatus.paginated));
      // call get all discount
    }
  }

  @override
  Future<void> close() {
    state.scrollController!.dispose();
    return super.close();
  }

  Future<void> onGetHomeDiscountProducts(
      GetHomeDiscountProducts event, Emitter<DiscountState> emit) async {
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
          productEntityHome: dataState.data,
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

  Future<void> onGetAllDiscountProducts(
      GetAllDiscountProducts event, Emitter<DiscountState> emit) async {
    if (state.isFirstDiscount!) {
      emit(state.copyWith(
          isFirstDiscount: false, discountCurrentIndex: event.page));
    }
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          discountStatus: DiscountStatus.errorAllDiscount));
      return;
    }

    try {
      final discountParams = DiscountParams(
          limit: event.limit,
          page: event.page + 1,
          sort: event.sort,
          language: event.language);

      final dataState = await _getDiscountUseCase(params: discountParams);

      if (dataState is DataSuccess) {
        ProductEntity discountProductsEntity = dataState.data!;

        int discountPaginationNumberSave = 1;

        if (discountProductsEntity.totalNumber != 1) {
          discountPaginationNumberSave =
              (discountProductsEntity.totalNumber! / event.limit).ceil();
        }

        state.productDiscountList!.addAll(discountProductsEntity.productList!);

        dataState.data!.productList!.forEach((element) {
          state.favorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          discountStatus: DiscountStatus.successAllDiscount,
          productAllDiscountEntity: discountProductsEntity,
          productDiscountList: state.productDiscountList,
          discountPaginationNumberSave: discountPaginationNumberSave,
          favorites: state.favorites,
          isDiscountHomeLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            discountStatus: DiscountStatus.errorAllDiscount));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          discountStatus: DiscountStatus.errorAllDiscount));
    }
  }

  Future<void> onAddToFavoriteDiscount(AddToFavoriteDiscount event, Emitter<DiscountState> emit) async {
    try {
      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere(
              (key, value) => key == event.productId && value == false);
          state.productDiscountList!.removeAt(event.index);
        }

        emit(state.copyWith(
          discountStatus: DiscountStatus.addedToFavorite,
          productDiscountList: state.productDiscountList,
          favorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            discountStatus: DiscountStatus.errorAddedToFavorite));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          discountStatus: DiscountStatus.errorAddedToFavorite));
    }
  }

  void onChangeSortDiscount(ChangeSortDiscount event, Emitter<DiscountState> emit) async {
    if (sort == 'newest') {
      sort = 'oldest';
    } else {
      sort = 'newest';
    }

    print(state.discountStatus);

    emit(state.copyWith(
        productDiscountList: [], discountStatus: DiscountStatus.changeSort));
    print(state.discountStatus);

  }
}
