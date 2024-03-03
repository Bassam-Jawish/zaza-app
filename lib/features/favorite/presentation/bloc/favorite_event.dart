part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class GetFavoriteProducts extends FavoriteEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;
  final String language;

  const GetFavoriteProducts(this.limit, this.page, this.sort, this.search, this.language);

  @override
  List<Object> get props => [limit, page, sort, search, search];
}

class AddToFavoriteFav extends FavoriteEvent {
  final int productId;
  final int index;
  const AddToFavoriteFav(this.productId, this.index);

  @override
  List<Object> get props => [productId, index];
}

class ChangeSortFavorite extends FavoriteEvent {
  const ChangeSortFavorite();

  @override
  List<Object> get props => [];
}