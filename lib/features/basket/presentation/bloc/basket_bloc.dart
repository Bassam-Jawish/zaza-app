import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../product/domain/entities/product.dart';

part 'basket_event.dart';

part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc()
      : super(BasketState().copyWith(basketStatus: BasketStatus.initial)) {
    on<GetBasketProducts>(onGetBasketProducts);
  }

  void onGetBasketProducts(GetBasketProducts event, Emitter<BasketState> emit) {
    emit(state.copyWith(basketStatus: BasketStatus.loading));
  }
}
