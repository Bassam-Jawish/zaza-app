part of 'basket_bloc.dart';

enum BasketStatus {
  initial,
  loading,
  success,
  error,
  add,
  remove,
  deleteAll,

  deleteAllWithLogout,
  editBasket,
  changeQuantity,
  errorAdded,
  getIds,
  clearController,
  errorAdd,
  loadingSendOrder,
  successSendOrder,
  errorSendOrder,

}

class BasketState extends Equatable {
  final bool? isLoading;
  final Failure? error;
  final ProductEntity? productEntity;
  List<ProductData>? basketProductsList;
  final int? basketPaginationNumberSave;
  final int? basketCurrentIndex;
  final BasketStatus? basketStatus;
  dynamic subTotal;
  dynamic total;
  final TextEditingController? quantityController;
  List<TextEditingController>? quantityControllers;
  List<ProductUnit>? productUnitHelper;

  final String? chosenQuantity;
  BasketState(
      {this.isLoading,
      this.error,
      this.productEntity,
      this.basketProductsList,
      this.basketPaginationNumberSave,
      this.basketCurrentIndex,
      this.basketStatus,
      this.subTotal,
      this.total,
      this.quantityController,
      this.quantityControllers,
      this.productUnitHelper, this.chosenQuantity});

  BasketState copyWith({
    bool? isLoading,
    Failure? error,
    ProductEntity? productEntity,
    List<ProductData>? basketProductsList,
    int? basketPaginationNumberSave,
    int? basketCurrentIndex,
    BasketStatus? basketStatus,
    dynamic subTotal,
    dynamic total,
    TextEditingController? quantityController,
    List<TextEditingController>? quantityControllers,
    List<ProductUnit>? productUnitHelper,
    String? chosenQuantity,
  }) =>
      BasketState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        productEntity: productEntity ?? this.productEntity,
        basketProductsList: basketProductsList ?? this.basketProductsList,
        basketPaginationNumberSave:
            basketPaginationNumberSave ?? this.basketPaginationNumberSave,
        basketCurrentIndex: basketCurrentIndex ?? this.basketCurrentIndex,
        basketStatus: basketStatus ?? this.basketStatus,
        subTotal: subTotal ?? this.subTotal,
        total: total ?? this.total,
        quantityController: quantityController ?? this.quantityController,
        quantityControllers: quantityControllers ?? this.quantityControllers,
        productUnitHelper: productUnitHelper ?? this.productUnitHelper,
        chosenQuantity: chosenQuantity ?? this.chosenQuantity,
      );

  @override
  List<Object?> get props => [
        isLoading,
        error,
        productEntity,
        basketProductsList,
        basketPaginationNumberSave,
        basketCurrentIndex,
        basketStatus,
        subTotal,
        total,
        quantityController,
        quantityControllers,
        productUnitHelper,
    chosenQuantity,
      ];
}
