import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/categories/data/models/category_parent_model.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/features/categories/data/models/unknown_type_model.dart';
import 'package:zaza_app/features/categories/domain/entities/category_entity.dart';
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

  CategoryBloc(this._getCategoriesUseCase, this._addToFavoritesUseCase,
      this._networkInfo)
      : super(CategoryState().copyWith(
            categoryStatus: CategoryStatus.initial,
            catId: 0,
            categoriesPaginated: [],
            productsPaginated: [],
            isPageLoaded: false,
            favorites: {},
            isAdded: false,
            currentIndex: 0,
            scrollController: ScrollController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetCategoryChildren>(onGetCategoryChildren);
    on<AddToFavoriteCategory>(onAddToFavoriteCategory);
    on<ChangeSortCategory>(onChangeSortCategory);
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
    if (event.isRefreshAll) {
      List<ProductData> productDiscountList = [];
      List<CategoryEntity> categoriesPaginated = [];
      emit(state.copyWith(
          discountCurrentIndex: event.page,
          isPageLoaded: false,
          categoriesPaginated: categoriesPaginated,
          productsPaginated: productDiscountList));
    }

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          categoryStatus: CategoryStatus.error,
          isPageLoaded: false));
      return;
    }

    try {
      final categoryParams = CategoryParams(
          id: event.id ?? '',
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
            isPageLoaded: true,
          ));
        } else {
          CategoryParentEntity categoryParentEntity =
              CategoryParentModel.fromJson(dataState.data!);

          List<CategoryEntity> categoriesPaginated = state.categoriesPaginated!;
          categoriesPaginated.addAll(categoryParentEntity!.categoriesChildren!);

          List<ProductData> productsPaginated = state.productsPaginated!;
          productsPaginated.addAll(categoryParentEntity!.productsChildren!);

          Map<int, bool> favorites = {};
          productsPaginated.forEach((element) {
            favorites!.addAll({
              element.productId!: element.isFavorite!,
            });
          });

          emit(state.copyWith(
              categoryStatus: CategoryStatus.success,
              categoryParentEntity: categoryParentEntity,
              productsPaginated: productsPaginated,
              categoriesPaginated: categoriesPaginated,
              favorites: favorites,
              isPageLoaded: true));
        }
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            categoryStatus: CategoryStatus.error,
            isPageLoaded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          categoryStatus: CategoryStatus.error,
          isPageLoaded: false));
    }
  }

  void onAddToFavoriteCategory(
      AddToFavoriteCategory event, Emitter<CategoryState> emit) async {
    try {
      emit(state.copyWith(isAdded: false));

      final addToFavoriteParams = AddToFavoriteParams(
        productId: event.productId,
      );

      final dataState =
          await _addToFavoritesUseCase(params: addToFavoriteParams);

      if (dataState is DataSuccess) {
        Map<int, bool> favorites = state.favorites!;
        int id = event.productId;
        favorites[id] = !favorites[id]!;

        emit(state.copyWith(
          categoryStatus: CategoryStatus.addedToFavorite,
          productsPaginated: state.productsPaginated,
          favorites: favorites,
          isAdded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        Map<int, bool> favorites = state.favorites!;
        favorites[event.productId] = !favorites[event.productId]!;
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            categoryStatus: CategoryStatus.errorAddedToFavorite,
            isAdded: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      Map<int, bool> favorites = state.favorites!;
      favorites[event.productId] = !favorites[event.productId]!;
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          categoryStatus: CategoryStatus.errorAddedToFavorite,
          isAdded: false));
    }
  }

  void onChangeSortCategory(
      ChangeSortCategory event, Emitter<CategoryState> emit) async {
    if (sort == 'newest') {
      sort = 'oldest';
    } else {
      sort = 'newest';
    }

    emit(state.copyWith(
        productsPaginated: [], categoryStatus: CategoryStatus.changeSort));

    // call get products
  }
}
