part of 'new_product_bloc.dart';

abstract class NewProductEvent extends Equatable {
  const NewProductEvent();
}

class GetAllNewProducts extends NewProductEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;

  final String language;

  const GetAllNewProducts(
      this.limit, this.page, this.sort, this.search, this.language);

  @override
  List<Object> get props => [limit, page, sort, search, language];
}

class AddToFavoriteNewProducts extends NewProductEvent {
  final int productId;
  final int index;
  const AddToFavoriteNewProducts(this.productId, this.index);

  @override
  List<Object> get props => [productId, index];
}

class ChangeSortNewProducts extends NewProductEvent {
  const ChangeSortNewProducts();

  @override
  List<Object> get props => [];
}