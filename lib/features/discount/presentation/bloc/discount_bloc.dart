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
            productDiscountList: [],
            isChanged: false,
            isDiscountHomeLoaded: false, isAdded: false)) {
    on<DiscountEvent>((event, emit) async {
      state.scrollController!.addListener(_scrollListener);
      if (event is GetHomeDiscountProducts)
        await onGetHomeDiscountProducts(event, emit);
      if (event is GetAllDiscountProducts)
        await onGetAllDiscountProducts(event, emit);
      if (event is AddToFavoriteDiscount)
        await onAddToFavoriteDiscount(event, emit);
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
    emit(state.copyWith(
        discountStatus: DiscountStatus.loading, isDiscountHomeLoaded: false));

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
          page: event.page + 1,
          sort: event.sort,
          language: event.language);

      final dataState = await _getDiscountUseCase(params: discountParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          productEntityHome: dataState.data,
          discountStatus: DiscountStatus.success,
          isDiscountHomeLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            discountStatus: DiscountStatus.error,
            isDiscountHomeLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          discountStatus: DiscountStatus.error,
          isDiscountHomeLoaded: false));
    }
  }

  Future<void> onGetAllDiscountProducts(
      GetAllDiscountProducts event, Emitter<DiscountState> emit) async {
    if (event.isRefreshAll) {
      List<ProductData> productDiscountList = [];
      emit(state.copyWith(
          isFirstDiscount: false,
          discountCurrentIndex: event.page,
          isDiscountHomeLoaded: false, productDiscountList: productDiscountList));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          discountStatus: DiscountStatus.errorAllDiscount, isDiscountHomeLoaded: false));
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

        List<ProductData> productDiscountList = event.isRefreshAll ? [] : state.productDiscountList!;
        productDiscountList!.addAll(discountProductsEntity.productList!);

        Map<int,bool>favorites = {};
        productDiscountList.forEach((element) {
          favorites!.addAll({
            element.productId!: element.isFavorite!,
          });
        });

        emit(state.copyWith(
          discountStatus: DiscountStatus.successAllDiscount,
          productAllDiscountEntity: discountProductsEntity,
          productDiscountList: productDiscountList,
          discountPaginationNumberSave: discountPaginationNumberSave,
          favorites: favorites,
          isDiscountHomeLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            discountStatus: DiscountStatus.errorAllDiscount,
            isDiscountHomeLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          discountStatus: DiscountStatus.errorAllDiscount,
          isDiscountHomeLoaded: false));
    }
  }

  Future<void> onAddToFavoriteDiscount(
      AddToFavoriteDiscount event, Emitter<DiscountState> emit) async {

    try {

      emit(state.copyWith(
          isAdded: false));

      Map<int, bool> favorites = state.favorites!;
      int id = event.productId;
      favorites[id] = !favorites[id]!;

      emit(state.copyWith(
        favorites: favorites,
        isAdded: true,
      ));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          discountStatus: DiscountStatus.addedToFavorite,
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

  void onChangeSortDiscount(
      ChangeSortDiscount event, Emitter<DiscountState> emit) async {
    if (sort == 'newest') {
      sort = 'oldest';
    } else {
      sort = 'newest';
    }
    emit(state.copyWith(discountStatus: DiscountStatus.changeSort));
  }
}
