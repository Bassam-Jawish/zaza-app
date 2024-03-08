part of 'product_bloc.dart';

enum ProductStatus {
  initial,
  loadingHomeNewProducts,
  successHomeNewProducts,
  errorHomeNewProducts,
  scannedBarcode,
  loadingBarcodeSearchPaginated,
  successBarcodeSearch,
  errorBarcodeSearch,
  loadingNameSearchPaginated,
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

  final ProductEntity? homeNewProductsEntity;

  final int? unitIndex;
  final ProductData? productProfile;
  final ProductStatus? productStatus;

  final String? scanBarcode;

  final bool? isNewHomeLoaded;

  final bool? isProductProfileLoaded;

  final bool? isAddedHomeNewProducts;

  ///////////////////////////////////////////////////

  final Map<int, bool>? searchBarcodeProductsFavorites;

  final ProductEntity? searchBarcodeProductsEntity;
  final bool? isAddedSearchByBarcode;

  final bool? isFirstSearchBarcode;
  final bool? isSearchByBarcodeLoaded;
  final ScrollController? scrollControllerSearchBarcode;

  final List<ProductData>? productSearchBarcodeList;

  ////////////////////

  final Map<int, bool>? searchNameProductsFavorites;

  final ProductEntity? searchNameProductsEntity;

  final bool? isAddedSearchByName;
  final bool? isFirstSearchName;
  final bool? isSearchByNameLoaded;
  final ScrollController? scrollControllerSearchName;

  final int? searchBarcodePaginationNumberSave;
  final int? searchBarcodeCurrentIndex;

  final int? searchNamePaginationNumberSave;
  final int? searchNameCurrentIndex;

  final List<ProductData>? productSearchNameList;

  //////////////////////////////////////////////////////////

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
      this.isAddedHomeNewProducts,
      this.isAddedSearchByBarcode,
      this.isFirstSearchBarcode,
      this.isSearchByBarcodeLoaded,
      this.scrollControllerSearchBarcode,
      this.isAddedSearchByName,
      this.isFirstSearchName,
      this.isSearchByNameLoaded,
      this.scrollControllerSearchName,
      this.searchBarcodePaginationNumberSave,
      this.searchBarcodeCurrentIndex,
      this.searchNamePaginationNumberSave,
      this.searchNameCurrentIndex,
      this.productSearchBarcodeList,
      this.productSearchNameList});

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
    bool? isAddedHomeNewProducts,
    bool? isAddedSearchByBarcode,
    bool? isFirstSearchBarcode,
    bool? isSearchByBarcodeLoaded,
    ScrollController? scrollControllerSearchBarcode,
    bool? isAddedSearchByName,
    bool? isFirstSearchName,
    bool? isSearchByNameLoaded,
    ScrollController? scrollControllerSearchName,
    int? searchBarcodePaginationNumberSave,
    int? searchBarcodeCurrentIndex,
    int? searchNamePaginationNumberSave,
    int? searchNameCurrentIndex,
    List<ProductData>? productSearchBarcodeList,
    List<ProductData>? productSearchNameList,
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
      isAddedHomeNewProducts:
          isAddedHomeNewProducts ?? this.isAddedHomeNewProducts,
      isAddedSearchByBarcode:
          isAddedSearchByBarcode ?? this.isAddedSearchByBarcode,
      isFirstSearchBarcode: isFirstSearchBarcode ?? this.isFirstSearchBarcode,
      isSearchByBarcodeLoaded:
          isSearchByBarcodeLoaded ?? this.isSearchByBarcodeLoaded,
      scrollControllerSearchBarcode:
          scrollControllerSearchBarcode ?? this.scrollControllerSearchBarcode,
      isAddedSearchByName: isAddedSearchByName ?? this.isAddedSearchByName,
      isFirstSearchName: isFirstSearchName ?? this.isFirstSearchName,
      isSearchByNameLoaded: isSearchByNameLoaded ?? this.isSearchByNameLoaded,
      scrollControllerSearchName:
          scrollControllerSearchName ?? this.scrollControllerSearchName,
      searchBarcodePaginationNumberSave: searchBarcodePaginationNumberSave ??
          this.searchBarcodePaginationNumberSave,
      searchBarcodeCurrentIndex:
          searchBarcodeCurrentIndex ?? this.searchBarcodeCurrentIndex,
      searchNamePaginationNumberSave:
          searchNamePaginationNumberSave ?? this.searchNamePaginationNumberSave,
      searchNameCurrentIndex:
          searchNameCurrentIndex ?? this.searchNameCurrentIndex,
      productSearchBarcodeList:
          productSearchBarcodeList ?? this.productSearchBarcodeList,
      productSearchNameList:
          productSearchNameList ?? this.productSearchNameList,
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
        isSearchByNameLoaded,
        isAddedHomeNewProducts,
        isAddedSearchByBarcode,
        isFirstSearchBarcode,
        isSearchByBarcodeLoaded,
        scrollControllerSearchBarcode,
        isAddedSearchByName,
        isFirstSearchName,
        isSearchByNameLoaded,
        scrollControllerSearchName,
        searchBarcodePaginationNumberSave,
        searchBarcodeCurrentIndex,
        searchNamePaginationNumberSave,
        searchNameCurrentIndex,
        productSearchBarcodeList,
        productSearchNameList,
      ];
}
