import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/categories/data/models/category_parent_model.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/features/categories/data/models/unknown_type_model.dart';
import 'package:zaza_app/features/categories/domain/entities/category_parent_entity.dart';
import 'package:zaza_app/features/categories/domain/entities/choose_type_entity.dart';
import 'package:zaza_app/features/categories/domain/entities/unknown_type_entity.dart';
import 'package:zaza_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../injection_container.dart';
import '../../../favorite/domain/usecases/add_to_favorites_usecase.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  final AddToFavoritesUseCase _addToFavoritesUseCase;

  final NetworkInfo _networkInfo;

  CategoryBloc(this._getCategoriesUseCase,this._addToFavoritesUseCase ,this._networkInfo)
      : super(CategoryState().copyWith(
            categoryStatus: CategoryStatus.initial,
            catId: 0,
            productsPaginated: [],
            isFirst: true,
            favorites: {},
            scrollController: ScrollController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetCategoryChildren>(onGetCategoryChildren);
    on<AddToFavorite>(onAddToFavorite);
    on<ChangeSort>(onChangeSort);
  }

  Future<void> _scrollListener() async {
    if (state.chooseTypeEntity == null) return;

    if (state.scrollController!.position.pixels ==
            state.scrollController!.position.maxScrollExtent &&
        state.currentIndex! + 1 != state.paginationNumberSave) {
      emit(state.copyWith(
          currentIndex: state.currentIndex! + 1,
          categoryStatus: CategoryStatus.paginated));
    }
  }

  @override
  Future<void> close() {
    state.scrollController!.dispose();
    return super.close();
  }

  void onGetCategoryChildren(
      GetCategoryChildren event, Emitter<CategoryState> emit) async {

    if (state.isFirst!) {
      emit(state.copyWith(
          isFirst: false, currentIndex: event.page));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          categoryStatus: CategoryStatus.error));
      return;
    }

    try {
      final categoryParams = CategoryParams(
          id: event.id,
          limit: event.limit,
          page: event.page + 1,
          language: event.language);

      final dataState = await _getCategoriesUseCase(params: categoryParams);

      if (dataState is DataSuccess) {
        int paginationNumberSave = 1;
        ChooseTypeEntity chooseTypeEntity =
            ChooseTypeModel.fromJson(dataState.data!);
        ;
        if (chooseTypeEntity.typeName == 'unknown') {
          print('unknown');
          paginationNumberSave = 1;
        } else {
          print('known');
          paginationNumberSave =
              (chooseTypeEntity.totalNumber! / event.limit).ceil();
        }

        emit(state.copyWith(
          categoryStatus: CategoryStatus.chooseType,
          chooseTypeEntity: chooseTypeEntity,
          paginationNumberSave: paginationNumberSave,
          screenType: chooseTypeEntity.typeName,
          catId: chooseTypeEntity.catId,
        ));

        if (chooseTypeEntity.typeName == 'unknown') {
          UnknownChildEntity unknownChildEntity =
              UnknownChildModel.fromJson(dataState.data!);

          emit(state.copyWith(
            categoryStatus: CategoryStatus.success,
            unknownChildEntity: unknownChildEntity,
          ));
        } else {
          CategoryParentEntity categoryParentEntity =
              CategoryParentModel.fromJson(dataState.data!);

            state.productsPaginated!.addAll(categoryParentEntity!.productsChildren!);

          state.productsPaginated!.forEach((element) {
            state.favorites!.addAll({
              element.productId!: element.isFavorite!,
            });
          });

          emit(state.copyWith(
            categoryStatus: CategoryStatus.success,
            categoryParentEntity: categoryParentEntity,
            productsPaginated: state.productsPaginated,
            favorites: state.favorites
          ));
        }
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            categoryStatus: CategoryStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          categoryStatus: CategoryStatus.error));
    }
  }


  void onAddToFavorite(
      AddToFavorite event, Emitter<CategoryState> emit) async {

    try {
      final addToFavoriteParams = AddToFavoriteParams(productId: event.productId,);

      final dataState = await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {

        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;

        if (favorites[event.productId]! == false) {
          favorites.removeWhere((key, value) => key == event.productId && value == false);
          state.productsPaginated!.removeAt(event.index);
        }

        emit(state.copyWith(
          categoryStatus: CategoryStatus.addedToFavorite,
          productsPaginated: state.productsPaginated,
          favorites: favorites,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            categoryStatus: CategoryStatus.errorAddedToFavorite));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          categoryStatus: CategoryStatus.errorAddedToFavorite));
    }

  }


  void onChangeSort(
      ChangeSort event, Emitter<CategoryState> emit) async {

    if (sort == 'newest') {
      sort = 'oldest';
    }
    else {
      sort = 'newest';
    }

    emit(state.copyWith(productsPaginated: [], categoryStatus: CategoryStatus.changeSort));

    // call get products

  }

}
