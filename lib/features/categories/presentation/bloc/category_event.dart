part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetCategoryChildren extends CategoryEvent {
  final dynamic id;
  final int limit;

  final int page;
  final String language;

  final bool isRefreshAll;

  const GetCategoryChildren(this.id, this.page, this.limit, this.language, this.isRefreshAll);

  @override
  List<Object> get props => [id, page, limit, language,isRefreshAll];
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