part of 'discount_bloc.dart';

enum DiscountStatus {
  initial,
  loading,
  success,
  error,
  paginated,
  successAllDiscount,
  errorAllDiscount,
  addedToFavorite,
  errorAddedToFavorite,
  changeSort
}

class DiscountState extends Equatable {
  final Failure? error;
  final ProductEntity? productEntityHome;

  final ProductEntity? productAllDiscountEntity;

  final List<ProductData>? productDiscountList;

  final int? discountPaginationNumberSave;
  final int? discountCurrentIndex;
  final DiscountStatus? discountStatus;
  final bool? isFirstDiscount;

  final ScrollController? scrollController;

  final Map<int, bool>? favorites;

  final bool? isDiscountHomeLoaded;

  const DiscountState(
      {this.error,
      this.productEntityHome,
      this.discountPaginationNumberSave,
      this.discountCurrentIndex,
      this.discountStatus,
      this.isFirstDiscount,
      this.productAllDiscountEntity,
      this.productDiscountList,
      this.scrollController,
      this.favorites,
      this.isDiscountHomeLoaded});

  DiscountState copyWith({
    Failure? error,
    ProductEntity? productEntityHome,
    int? discountPaginationNumberSave,
    int? discountCurrentIndex,
    DiscountStatus? discountStatus,
    bool? isFirstDiscount,
    ProductEntity? productAllDiscountEntity,
    List<ProductData>? productDiscountList,
    ScrollController? scrollController,
    Map<int, bool>? favorites,
    bool? isDiscountHomeLoaded,
  }) =>
      DiscountState(
        error: error ?? this.error,
        productEntityHome: productEntityHome ?? this.productEntityHome,
        discountPaginationNumberSave:
            discountPaginationNumberSave ?? this.discountPaginationNumberSave,
        discountCurrentIndex: discountCurrentIndex ?? this.discountCurrentIndex,
        discountStatus: discountStatus ?? this.discountStatus,
        isFirstDiscount: isFirstDiscount ?? this.isFirstDiscount,
        productAllDiscountEntity:
            productAllDiscountEntity ?? this.productAllDiscountEntity,
        productDiscountList: productDiscountList ?? this.productDiscountList,
        scrollController: scrollController ?? this.scrollController,
        favorites: favorites ?? this.favorites,
        isDiscountHomeLoaded: isDiscountHomeLoaded ?? this.isDiscountHomeLoaded,
      );

  @override
  List<Object?> get props => [
        error,
        productEntityHome,
        discountPaginationNumberSave,
        discountCurrentIndex,
        discountStatus,
        isFirstDiscount,
        productAllDiscountEntity,
        productDiscountList,
        scrollController,
        isDiscountHomeLoaded,
      ];
}
