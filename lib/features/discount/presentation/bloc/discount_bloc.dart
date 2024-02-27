import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product.dart';

part 'discount_event.dart';

part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  DiscountBloc()
      : super(
            DiscountState().copyWith(discountStatus: DiscountStatus.initial)) {
    on<GetDiscountProducts>(onGetDiscountProducts);
  }

  void onGetDiscountProducts(
      GetDiscountProducts event, Emitter<DiscountState> emit) async {



  }
}
