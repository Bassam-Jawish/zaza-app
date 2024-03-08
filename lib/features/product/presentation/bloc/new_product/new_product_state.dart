part of 'new_product_bloc.dart';


enum NewProductStatus {
  initial,
  loadingAllNewProductsPaginated,
  successAllNewProducts,
  errorAllNewProducts,addedToFavorite , errorAddedToFavorite, changeSort
}

class NewProductState extends Equatable {
  final Failure? error;

  final bool? isNewProductsLoaded;

  final int? newProductsCurrentIndex;
  final int? newProductsPaginationNumberSave;
  final Map<int, bool>? newAllProductsFavorites;

  final ProductEntity? newAllProductsEntity;

  final List<ProductData>? newAllProductsList;

  final ScrollController? scrollController;

  final NewProductStatus? newProductStatus;

  final bool? isAddedNewProducts;

  NewProductState({
    this.error,
    this.isNewProductsLoaded,
    this.newProductsCurrentIndex,
    this.newProductsPaginationNumberSave,
    this.newAllProductsFavorites,
    this.newAllProductsEntity,
    this.newAllProductsList,
    this.scrollController,
    this.newProductStatus,
    this.isAddedNewProducts,
  });

  // CopyWith method
  NewProductState copyWith({
    Failure? error,
    bool? isNewProductsLoaded,
    int? newProductsCurrentIndex,
    int? newProductsPaginationNumberSave,
    Map<int, bool>? newAllProductsFavorites,
    ProductEntity? newAllProductsEntity,
    List<ProductData>? newAllProductsList,
    ScrollController? scrollController,
    NewProductStatus? newProductStatus,
    bool? isAddedNewProducts,
  }) {
    return NewProductState(
      error: error ?? this.error,
      isNewProductsLoaded:
      isNewProductsLoaded ?? this.isNewProductsLoaded,
      newProductsCurrentIndex:
      newProductsCurrentIndex ?? this.newProductsCurrentIndex,
      newProductsPaginationNumberSave: newProductsPaginationNumberSave ??
          this.newProductsPaginationNumberSave,
      newAllProductsFavorites:
      newAllProductsFavorites ?? this.newAllProductsFavorites,
      newAllProductsEntity: newAllProductsEntity ?? this.newAllProductsEntity,
      newAllProductsList: newAllProductsList ?? this.newAllProductsList,
      scrollController: scrollController ?? this.scrollController,
      newProductStatus: newProductStatus ?? this.newProductStatus,
      isAddedNewProducts: isAddedNewProducts ?? this.isAddedNewProducts,
    );
  }

  @override
  List<Object?> get props => [
    error,
    isNewProductsLoaded,
    newProductsCurrentIndex,
    newProductsPaginationNumberSave,
    newAllProductsFavorites,
    newAllProductsEntity,
    newAllProductsList,
    scrollController,
    newProductStatus,
    isAddedNewProducts,
  ];
}
