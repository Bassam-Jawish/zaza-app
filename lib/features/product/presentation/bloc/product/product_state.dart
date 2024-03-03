part of 'product_bloc.dart';

enum ProductStatus {
  initial,
  loadingHomeNewProducts,
  successHomeNewProducts,
  errorHomeNewProducts,
  scannedBarcode,
  loadingBarcodeSearch,
  successBarcodeSearch,
  errorBarcodeSearch,
  loadingNameSearch,
  successNameSearch,
  errorNameSearch,
  loadingProductProfile,
  successProductProfile,
  errorProductProfile,
  changeUnitIndex,
  addedToFavoriteNewProducts,
  errorAddedToFavoriteNewProducts,
  addedToFavoriteSearchByBarcode,
  errorAddedToFavoriteSearchByBarcode,
  addedToFavoriteSearchByName,
  errorAddedToFavoriteSearchByName,
}

class ProductState extends Equatable {
  final Failure? error;

  final Map<int, bool>? newHomeProductsFavorites;
  final Map<int, bool>? searchBarcodeProductsFavorites;
  final Map<int, bool>? searchNameProductsFavorites;

  final ProductEntity? homeNewProductsEntity;
  final ProductEntity? searchBarcodeProductsEntity;
  final ProductEntity? searchNameProductsEntity;

  final int? unitIndex;
  final ProductData? productProfile;
  final ProductStatus? productStatus;

  final String? scanBarcode;

  final bool? isNewHomeLoaded;

  final bool? isProductProfileLoaded;

  final bool? isSearchByBarcodeLoaded;

  final bool? isSearchByNameLoaded;

  ProductState(
      {this.error,
      this.newHomeProductsFavorites,
      this.searchBarcodeProductsFavorites,
      this.searchNameProductsFavorites,
      this.homeNewProductsEntity,
      this.searchBarcodeProductsEntity,
      this.searchNameProductsEntity,
      this.unitIndex,
      this.productProfile,
      this.productStatus,
      this.scanBarcode,
      this.isNewHomeLoaded,
      this.isProductProfileLoaded,
      this.isSearchByBarcodeLoaded,
      this.isSearchByNameLoaded});

  // CopyWith method
  ProductState copyWith({
    Failure? error,
    Map<int, bool>? newHomeProductsFavorites,
    Map<int, bool>? searchBarcodeProductsFavorites,
    Map<int, bool>? searchNameProductsFavorites,
    ProductEntity? homeNewProductsEntity,
    ProductEntity? searchBarcodeProductsEntity,
    ProductEntity? searchNameProductsEntity,
    int? unitIndex,
    ProductData? productProfile,
    ProductStatus? productStatus,
    String? scanBarcode,
    bool? isNewHomeLoaded,
    bool? isProductProfileLoaded,
    bool? isSearchByBarcodeLoaded,
    bool? isSearchByNameLoaded,
  }) {
    return ProductState(
      error: error ?? this.error,
      newHomeProductsFavorites:
          newHomeProductsFavorites ?? this.newHomeProductsFavorites,
      searchBarcodeProductsFavorites:
          searchBarcodeProductsFavorites ?? this.searchBarcodeProductsFavorites,
      searchNameProductsFavorites:
          searchNameProductsFavorites ?? this.searchNameProductsFavorites,
      homeNewProductsEntity:
          homeNewProductsEntity ?? this.homeNewProductsEntity,
      searchBarcodeProductsEntity:
          searchBarcodeProductsEntity ?? this.searchBarcodeProductsEntity,
      searchNameProductsEntity:
          searchNameProductsEntity ?? this.searchNameProductsEntity,
      unitIndex: unitIndex ?? this.unitIndex,
      productProfile: productProfile ?? this.productProfile,
      productStatus: productStatus ?? this.productStatus,
      scanBarcode: scanBarcode ?? this.scanBarcode,
      isNewHomeLoaded: isNewHomeLoaded ?? this.isNewHomeLoaded,
      isProductProfileLoaded:
          isProductProfileLoaded ?? this.isProductProfileLoaded,
      isSearchByBarcodeLoaded:
          isSearchByBarcodeLoaded ?? this.isSearchByBarcodeLoaded,
      isSearchByNameLoaded: isSearchByNameLoaded ?? this.isSearchByNameLoaded,
    );
  }

  @override
  List<Object?> get props => [
        error,
        newHomeProductsFavorites,
        searchBarcodeProductsFavorites,
        searchNameProductsFavorites,
        homeNewProductsEntity,
        searchBarcodeProductsEntity,
        searchNameProductsEntity,
        unitIndex,
        productProfile,
        productStatus,
        scanBarcode,
        isNewHomeLoaded,
        isProductProfileLoaded,
        isSearchByBarcodeLoaded,
        isSearchByNameLoaded
      ];
}
