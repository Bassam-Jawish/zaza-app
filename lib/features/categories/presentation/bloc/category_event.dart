part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetCategoryChildren extends CategoryEvent {
  final dynamic id;
  final int limit;

  final int page;
  final String language;

  const GetCategoryChildren(this.id, this.page, this.limit, this.language);

  @override
  List<Object> get props => [id, page, limit, language];
}


class AddToFavoriteCategory extends CategoryEvent {
  final int productId;
  final int index;
  const AddToFavoriteCategory(this.productId, this.index);

  @override
  List<Object> get props => [productId, index];
}

class ChangeSortCategory extends CategoryEvent {
  const ChangeSortCategory();

  @override
  List<Object> get props => [];
}