part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class GetFavoriteProducts extends FavoriteEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;
  final String status;

  const GetFavoriteProducts(this.limit, this.page, this.sort, this.search, this.status);

  @override
  List<Object> get props => [limit, page, sort, search, search];
}

class AddToFavorite extends FavoriteEvent {
  final int productId;
  final int index;
  const AddToFavorite(this.productId, this.index);

  @override
  List<Object> get props => [productId, index];
}

class ChangeSort extends FavoriteEvent {
  const ChangeSort();

  @override
  List<Object> get props => [];
}