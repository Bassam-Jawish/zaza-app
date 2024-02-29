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

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final NetworkInfo _networkInfo;

  CategoryBloc(this._getCategoriesUseCase, this._networkInfo)
      : super(CategoryState().copyWith(
            categoryStatus: CategoryStatus.initial,
            catId: 0,
            productsPaginated: [],
            isFirst: true,
            scrollController: ScrollController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetCategoryChildren>(onGetCategoryChildren);
  }

  Future<void> _scrollListener() async {
    if (state.chooseTypeEntity == null) return;

    if (state.scrollController!.position.pixels ==
            state.scrollController!.position.maxScrollExtent &&
        state.currentIndex! + 1 != state.paginationNumberSave) {
      emit(state.copyWith(
          currentIndex: state.currentIndex! + 1,
          categoryStatus: CategoryStatus.paginated));


      //await getCategoryChildren(limit: limit, page: currentIndex, id: categoryId);

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
          emit(state.copyWith(
            categoryStatus: CategoryStatus.success,
            categoryParentEntity: categoryParentEntity,
            productsPaginated: state.productsPaginated,
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
}
