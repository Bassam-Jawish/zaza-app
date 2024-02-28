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
