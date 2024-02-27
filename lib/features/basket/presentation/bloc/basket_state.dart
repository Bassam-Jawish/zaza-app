part of 'basket_bloc.dart';

enum BasketStatus { initial, loading, success, error }

class BasketState extends Equatable {
  final bool? isLoading;
  final Failure? error;
  final ProductEntity? productEntity;
  final int? basketPaginationNumberSave;
  final int? basketCurrentIndex;
  final BasketStatus? basketStatus;
  dynamic subTotal = 0.0;
  dynamic total = 0.0;
  TextEditingController? quantityController = TextEditingController();

  List<TextEditingController>? quantityControllers = [];
  List<ProductUnit>? productUnitHelper;

  BasketState(
      {this.isLoading,
      this.error,
      this.productEntity,
      this.basketPaginationNumberSave,
      this.basketCurrentIndex,
      this.basketStatus,
      this.subTotal,
      this.total,
      this.quantityController});

  BasketState copyWith({
    bool? isLoading,
    Failure? error,
    ProductEntity? productEntity,
    int? basketPaginationNumberSave,
    int? basketCurrentIndex,
    BasketStatus? basketStatus,
  }) =>
      BasketState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        productEntity: productEntity ?? this.productEntity,
        basketPaginationNumberSave:
            basketPaginationNumberSave ?? this.basketPaginationNumberSave,
        basketCurrentIndex: basketCurrentIndex ?? this.basketCurrentIndex,
        basketStatus: basketStatus ?? this.basketStatus,
      );

  @override
  List<Object?> get props => [
        isLoading,
        error,
        productEntity,
        basketPaginationNumberSave,
        basketCurrentIndex,
        basketStatus
      ];
}
