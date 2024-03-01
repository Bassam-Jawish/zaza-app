part of 'category_bloc.dart';

enum CategoryStatus { initial,paginated,success, error, chooseType, addedToFavorite , errorAddedToFavorite,changeSort}
class CategoryState extends Equatable {
  final Failure? error;
  final String? screenType;
  final int? catId;
  final int? discountCurrentIndex;

  final int? paginationNumberSave;

  final int? currentIndex;

  final ChooseTypeEntity? chooseTypeEntity;

  final UnknownChildEntity? unknownChildEntity;

  final CategoryParentEntity? categoryParentEntity;

  final List<ProductData>? productsPaginated;

  final CategoryStatus? categoryStatus;

  final ScrollController? scrollController;

  final bool? isFirst;

  final Map<int, bool>? favorites;


  CategoryState({
    this.error,
    this.screenType,
    this.catId,
    this.discountCurrentIndex,
    this.paginationNumberSave,
    this.currentIndex,
    this.chooseTypeEntity,
    this.unknownChildEntity,
    this.categoryParentEntity,
    this.productsPaginated,
    this.categoryStatus,
    this.scrollController,
    this.isFirst,
    this.favorites
  });

  @override
  List<Object?> get props => [
    error,
    screenType,
    catId,
    discountCurrentIndex,
    paginationNumberSave,
    currentIndex,
    chooseTypeEntity,
    unknownChildEntity,
    categoryParentEntity,
    productsPaginated,
    categoryStatus,
    scrollController,
    isFirst,
    favorites,
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
    List<ProductData>? productsPaginated,
    CategoryStatus? categoryStatus,
    ScrollController? scrollController,
    bool? isFirst,
    Map<int, bool>? favorites,

  }) {
    return CategoryState(
      error: error ?? this.error,
      screenType: screenType ?? this.screenType,
      catId: catId ?? this.catId,
      discountCurrentIndex: discountCurrentIndex ?? this.discountCurrentIndex,
      paginationNumberSave: paginationNumberSave ?? this.paginationNumberSave,
      currentIndex: currentIndex ?? this.currentIndex,
      chooseTypeEntity: chooseTypeEntity ?? this.chooseTypeEntity,
      unknownChildEntity: unknownChildEntity ?? this.unknownChildEntity,
      categoryParentEntity: categoryParentEntity ?? this.categoryParentEntity,
      productsPaginated: productsPaginated ?? this.productsPaginated,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      scrollController: scrollController ?? this.scrollController,
      isFirst: isFirst ?? this.isFirst,
      favorites: favorites ?? this.favorites,
    );
  }
}
