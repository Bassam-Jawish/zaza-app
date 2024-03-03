part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, paginated, success, error, addedToFavorite , errorAddedToFavorite, changeSort }

class FavoriteState extends Equatable {
  final Failure? error;
  final ProductEntity? favoriteProductsEntity;
  final int? favoritePaginationNumberSave;
  final int? favoriteCurrentIndex;
  final FavoriteStatus? favoriteStatus;

  final List <ProductData>? favoriteProductsList;

  final Map<int, bool>? favorites;

  final ScrollController? scrollController;

  final int? totalNumber;
  final bool? isFirst;

  FavoriteState({
    this.error,
    this.favoriteProductsEntity,
    this.favoritePaginationNumberSave,
    this.favoriteCurrentIndex,
    this.favoriteStatus,
    this.favoriteProductsList,
    this.favorites,
    this.scrollController,
    this.totalNumber,
    this.isFirst
  });

  FavoriteState copyWith({
    Failure? error,
    ProductEntity? favoriteProductsEntity,
    int? favoritePaginationNumberSave,
    int? favoriteCurrentIndex,
    FavoriteStatus? favoriteStatus,
    List<ProductData>? favoriteProductsList,
    Map<int, bool>? favorites,
    ScrollController? scrollController,
    int? totalNumber,
    bool? isFirst,
  }) {
    return FavoriteState(
      error: error ?? this.error,
      favoriteProductsEntity: favoriteProductsEntity ?? this.favoriteProductsEntity,
      favoritePaginationNumberSave: favoritePaginationNumberSave ?? this.favoritePaginationNumberSave,
      favoriteCurrentIndex: favoriteCurrentIndex ?? this.favoriteCurrentIndex,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      favoriteProductsList: favoriteProductsList ?? this.favoriteProductsList,
      favorites: favorites ?? this.favorites,
      scrollController: scrollController ?? this.scrollController,
      totalNumber: totalNumber ?? this.totalNumber,
      isFirst: isFirst ?? this.isFirst,
    );
  }

  @override
  List<Object?> get props => [
    error,
    favoriteProductsEntity,
    favoritePaginationNumberSave,
    favoriteCurrentIndex,
    favoriteStatus,
    favoriteProductsList,
    favorites,
    scrollController,
    totalNumber,
    isFirst,
  ];
}
