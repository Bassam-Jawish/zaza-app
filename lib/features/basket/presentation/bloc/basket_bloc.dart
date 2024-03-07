import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/basket/domain/usecases/add_to_basket_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/delete_basket_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/edit_basket_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/get_basket_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/get_id_quantity_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/remove_one_basket_usecase.dart';
import 'package:zaza_app/features/basket/domain/usecases/send_order_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../product/domain/entities/product.dart';
import '../../data/models/product_unit.dart';

part 'basket_event.dart';

part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final GetBasketUseCase _getBasketUseCase;

  final GetIdQuantityBasketUseCase _getIdQuantityBasketUseCase;

  final EditQuantityBasketUseCase _editQuantityBasketUseCase;

  final AddToBasketUseCase _addToBasketUseCase;

  final RemoveOneBasketUseCase _removeOneBasketUseCase;

  final DeleteBasketUseCase _deleteBasketUseCase;

  final SendOrdersUseCase _sendOrdersUseCase;

  final NetworkInfo _networkInfo;

  BasketBloc(
      this._getBasketUseCase,
      this._getIdQuantityBasketUseCase,
      this._editQuantityBasketUseCase,
      this._addToBasketUseCase,
      this._removeOneBasketUseCase,
      this._deleteBasketUseCase,
      this._sendOrdersUseCase,
      this._networkInfo)
      : super(BasketState().copyWith(
            basketStatus: BasketStatus.initial,
            subTotal: 0.0,
            total: 0.0,
            basketProductsList: [],
            productUnitHelper: [],
            isLoading: false,quantityController: TextEditingController(), chosenQuantity: '')) {

    on<BasketEvent>((event, emit) async {
      if (event is GetBasketProducts) await onGetBasketProducts(event, emit);
      else if (event is ClearQuantityController) onClearQuantityController(event, emit);
      else if (event is ChangeTextValue) onChangeTextValue(event, emit);
      else if (event is GetIdQuantityForBasket) await onGetIdQuantityForBasket(event, emit);
      else if (event is AddToBasket) await onAddToBasket(event, emit);
      else if (event is EditQuantityBasket) await onEditQuantityBasket(event, emit);
      else if (event is RemoveOneFromBasket) await onRemoveOneFromBasket(event, emit);
      else if (event is DeleteBasket) await onDeleteBasket(event, emit);
      else if (event is SendOrder) await onSendOrder(event, emit);
    });
  }

  Future<void> onGetBasketProducts(
      GetBasketProducts event, Emitter<BasketState> emit) async {
    emit(state.copyWith(basketStatus: BasketStatus.loading));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          basketStatus: BasketStatus.error));
      return;
    }

    try {
      List<dynamic> idList = state.productUnitHelper!
          .map((ProductUnit product) => product.product_unit_id)
          .toList();

      List<dynamic> quantityList =
          state.productUnitHelper!.map((product) => product.quantity).toList();

      print('idList=${idList}');

      print('quantityList=${quantityList}');

      final basketParams = BasketParams(
          limit: event.limit,
          page: event.page + 1,
          language: event.languageCode,
          idList: idList);

      final dataState = await _getBasketUseCase(params: basketParams);

      if (dataState is DataSuccess) {
        int? basketPaginationNumberSave;

        List<ProductData> basketProductsList = [];

        dynamic total = 0.0;

        dynamic subTotal = 0.0;

        List<TextEditingController> quantityControllers = [];

        basketProductsList.addAll(dataState.data!.productList!);

        if (dataState.data!.totalNumber! == 0) {
          basketPaginationNumberSave = 1;
        } else {
          basketPaginationNumberSave =
              (dataState.data!.totalNumber! / event.limit).ceil();
        }

////////////////////////////////////
        basketProductsList.asMap().forEach((index, element) {
          dynamic price = element.productUnitListModel![0].price;
          int myQuantity = state.productUnitHelper![index].quantity!;
          subTotal += price * myQuantity;
        });

        basketProductsList.asMap().forEach((index, element) {
          dynamic price = element.productUnitListModel![0].price;
          int myQuantity = state.productUnitHelper![index].quantity!;
          int discount = element.discount!;
          total += ((price * (100 - discount)) / 100) * myQuantity;
          print('total=${total}');
        });
///////////////////////////////////

        quantityControllers = quantityList.map((initialText) {
          return TextEditingController(text: initialText.toString());
        }).toList();

        emit(state.copyWith(
          productEntity: dataState.data,
          basketStatus: BasketStatus.success,
          basketProductsList: basketProductsList,
          quantityControllers: quantityControllers,
          total: total,
          subTotal: subTotal,
          basketPaginationNumberSave: basketPaginationNumberSave,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            basketStatus: BasketStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          basketStatus: BasketStatus.error));
    }
  }

  void onClearQuantityController(
      ClearQuantityController event, Emitter<BasketState> emit) {
    TextEditingController copy = state.quantityController!;

    copy.clear();

    emit(state.copyWith(
        quantityController: copy, basketStatus: BasketStatus.clearController));
  }

  void onChangeTextValue(ChangeTextValue event, Emitter<BasketState> emit) {
    emit(state.copyWith(basketStatus: BasketStatus.changeQuantity,chosenQuantity: event.chosenQuantity));
  }

  Future<void> onGetIdQuantityForBasket(
      GetIdQuantityForBasket event, Emitter<BasketState> emit) async {
    final dataState = await _getIdQuantityBasketUseCase();

    if (dataState is DataSuccess) {
      emit(state.copyWith(
          productUnitHelper: dataState.data,
          basketStatus: BasketStatus.getIds));
      // call onGetBasketProducts
    }
  }

  Future<void> onAddToBasket(
      AddToBasket event, Emitter<BasketState> emit) async {
    print(event.productUnitId);
    print(event.quantity);

    final addToBasketParams = AddToBasketParams(
        product_unit_id: event.productUnitId, quantity: event.quantity);

    final dataState = await _addToBasketUseCase(params: addToBasketParams);

    if (dataState is DataSuccess) {
      emit(state.copyWith(basketStatus: BasketStatus.add,));
      // call onGetIdQuantityForBasket
      // call onGetBasketProducts
    }

    if (dataState is DataFailed2) {
      debugPrint(dataState.hiveError!.message);
      emit(state.copyWith(
          error: DatabaseFailure(dataState.hiveError!.message!),
          basketStatus: BasketStatus.errorAdd));
    }
  }

  Future<void> onEditQuantityBasket(
      EditQuantityBasket event, Emitter<BasketState> emit) async {
    final editQuantityBasketParams = EditQuantityBasketParams(
        product_unit_id: event.productUnitId,
        quantity: event.quantity,
        index: event.index);

    final dataState =
        await _editQuantityBasketUseCase(params: editQuantityBasketParams);

    if (dataState is DataSuccess) {
      dynamic price =
          state.basketProductsList![event.index].productUnitListModel![0].price;
      dynamic myQuantity = state.productUnitHelper![event.index].quantity;
      dynamic discount = state.basketProductsList![event.index].discount!;

      dynamic subTotal = state.subTotal - (myQuantity * price);
      dynamic total =
          state.total - (((price * (100 - discount)) / 100) * myQuantity);

      subTotal += event.quantity * price;
      total += ((price * (100 - discount)) / 100) * event.quantity;

      emit(state.copyWith(
          subTotal: subTotal,
          total: total,
          basketStatus: BasketStatus.editBasket));

      // call onGetIdQuantityForBasket
      // call onGetBasketProducts
    }
  }

  Future<void> onRemoveOneFromBasket(
      RemoveOneFromBasket event, Emitter<BasketState> emit) async {
    final removeOneBasketParams = RemoveOneBasketParams(index: event.index);

    final dataState =
        await _removeOneBasketUseCase(params: removeOneBasketParams);

    if (dataState is DataSuccess) {
      dynamic price =
          state.basketProductsList![event.index].productUnitListModel![0].price;
      dynamic myQuantity = state.productUnitHelper![event.index].quantity;
      dynamic discount = state.basketProductsList![event.index].discount!;

      dynamic subTotal = state.subTotal - (myQuantity * price);
      dynamic total =
          state.total - (((price * (100 - discount)) / 100) * myQuantity);

      List<ProductData> copy = state.basketProductsList!;
      copy.removeAt(event.index);

      emit(state.copyWith(
          subTotal: subTotal,
          total: total,
          basketStatus: BasketStatus.remove,
          basketProductsList: copy));

      // call onGetIdQuantityForBasket
      // call onGetBasketProducts
    }
  }

  Future<void> onDeleteBasket(
      DeleteBasket event, Emitter<BasketState> emit) async {
    final dataState = await _deleteBasketUseCase();

    if (dataState is DataSuccess) {
      dynamic subTotal = 0.0;
      dynamic total = 0.0;

      List<ProductData> copy = state.basketProductsList!;
      copy.clear();

      emit(state.copyWith(
        subTotal: subTotal,
        total: total,
        basketStatus: BasketStatus.deleteAll,
        basketProductsList: copy,
      ));

      // call onGetIdQuantityForBasket
      // call onGetBasketProducts
    }
  }

  Future<void> onSendOrder(SendOrder event, Emitter<BasketState> emit) async {
    emit(state.copyWith(
        basketStatus: BasketStatus.loadingSendOrder, isLoading: true));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          basketStatus: BasketStatus.errorSendOrder,
          isLoading: false));
      return;
    }

    try {
      final sendOrder = SendOrderParams(
          language: event.language,
          productUnitHelper: state.productUnitHelper!);

      final dataState = await _sendOrdersUseCase(params: sendOrder);

      if (dataState is DataSuccess) {
        dynamic total = 0.0;
        dynamic subTotal = 0.0;

        emit(state.copyWith(
            productEntity: dataState.data,
            basketStatus: BasketStatus.successSendOrder,
            total: total,
            subTotal: subTotal,
            isLoading: true));

        // call delete all
        // call onGetIdQuantityForBasket
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            basketStatus: BasketStatus.errorSendOrder,
            isLoading: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          basketStatus: BasketStatus.errorSendOrder,
          isLoading: false));
    }
  }
}
