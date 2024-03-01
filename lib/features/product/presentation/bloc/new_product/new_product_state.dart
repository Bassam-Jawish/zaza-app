part of 'new_product_bloc.dart';


enum NewProductStatus {
  initial,
  loadingAllNewProductsPaginated,
  successAllNewProducts,
  errorAllNewProducts,addedToFavorite , errorAddedToFavorite, changeSort
}

class NewProductState extends Equatable {
  final Failure? error;

  final bool? isFirstNewProductsLoading;

  final int? newProductsCurrentIndex;
  final int? newProductsPaginationNumberSave;
  final Map<int, bool>? newAllProductsFavorites;

  final ProductEntity? newAllProductsEntity;

  final List<ProductData>? newAllProductsList;

  final ScrollController? scrollController;

  final NewProductStatus? newProductStatus;


  NewProductState({
    this.error,
    this.isFirstNewProductsLoading,
    this.newProductsCurrentIndex,
    this.newProductsPaginationNumberSave,
    this.newAllProductsFavorites,
    this.newAllProductsEntity,
    this.newAllProductsList,
    this.scrollController,
    this.newProductStatus,
  });

  // CopyWith method
  NewProductState copyWith({
    Failure? error,
    bool? isFirstNewProductsLoading,
    int? newProductsCurrentIndex,
    int? newProductsPaginationNumberSave,
    Map<int, bool>? newAllProductsFavorites,
    ProductEntity? newAllProductsEntity,
    List<ProductData>? newAllProductsList,
    ScrollController? scrollController,
    NewProductStatus? newProductStatus,
  }) {
    return NewProductState(
      error: error ?? this.error,
      isFirstNewProductsLoading:
      isFirstNewProductsLoading ?? this.isFirstNewProductsLoading,
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
    );
  }

  @override
  List<Object?> get props => [
    error,
    isFirstNewProductsLoading,
    newProductsCurrentIndex,
    newProductsPaginationNumberSave,
    newAllProductsFavorites,
    newAllProductsEntity,
    newAllProductsList,
    scrollController,
    newProductStatus,
  ];
}
