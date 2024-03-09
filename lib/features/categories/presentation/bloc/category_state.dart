part of 'category_bloc.dart';

enum CategoryStatus { initial,paginated,success, error, chooseType, addedToFavorite , errorAddedToFavorite,changeSort}
class CategoryState extends Equatable {
  final Failure? error;
  final String? screenType;
  final int? catId;

  final int? paginationNumberSave;

  final int? currentIndex;

  final ChooseTypeEntity? chooseTypeEntity;

  final UnknownChildEntity? unknownChildEntity;

  final CategoryParentEntity? categoryParentEntity;

  final List<CategoryEntity>? categoriesPaginated;

  final List<ProductData>? productsPaginated;

  final CategoryStatus? categoryStatus;

  final ScrollController? scrollController;

  final bool? isPageLoaded;

  final Map<int, bool>? favorites;


  final bool? isAdded;


  CategoryState({
    this.error,
    this.screenType,
    this.catId,
    this.paginationNumberSave,
    this.currentIndex,
    this.chooseTypeEntity,
    this.unknownChildEntity,
    this.categoryParentEntity,
    this.categoriesPaginated,
    this.productsPaginated,
    this.categoryStatus,
    this.scrollController,
    this.isPageLoaded,
    this.favorites,
    this.isAdded
  });

  @override
  List<Object?> get props => [
    error,
    screenType,
    catId,
    paginationNumberSave,
    currentIndex,
    chooseTypeEntity,
    unknownChildEntity,
    categoryParentEntity,
    categoriesPaginated,
    productsPaginated,
    categoryStatus,
    scrollController,
    isPageLoaded,
    favorites,
    isAdded,
  ];

  CategoryState copyWith({
    Failure? error,
    String? screenType,
    int? catId,
    int? discountCurrentIndex,
    int? paginationNumberSave,
    int? currentIndex,
    ChooseTypeEntity? chooseTypeEntity,
    UnknownChildEntity? unknownChildEntity,
    CategoryParentEntity? categoryParentEntity,
    List<CategoryEntity>? categoriesPaginated,
    List<ProductData>? productsPaginated,
    CategoryStatus? categoryStatus,
    ScrollController? scrollController,
    bool? isPageLoaded,
    Map<int, bool>? favorites,
    bool? isRefreshAll,
    bool? isAdded,
  }) {
    return CategoryState(
      error: error ?? this.error,
      screenType: screenType ?? this.screenType,
      catId: catId ?? this.catId,
      paginationNumberSave: paginationNumberSave ?? this.paginationNumberSave,
      currentIndex: currentIndex ?? this.currentIndex,
      chooseTypeEntity: chooseTypeEntity ?? this.chooseTypeEntity,
      unknownChildEntity: unknownChildEntity ?? this.unknownChildEntity,
      categoryParentEntity: categoryParentEntity ?? this.categoryParentEntity,
      categoriesPaginated: categoriesPaginated ?? this.categoriesPaginated,
      productsPaginated: productsPaginated ?? this.productsPaginated,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      scrollController: scrollController ?? this.scrollController,
      isPageLoaded: isPageLoaded ?? this.isPageLoaded,
      favorites: favorites ?? this.favorites,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}
