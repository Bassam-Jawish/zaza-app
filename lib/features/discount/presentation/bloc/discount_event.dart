part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();
}

class GetHomeDiscountProducts extends DiscountEvent {
  final int limit;
  final int page;
  final String sort;

  final dynamic language;

  const GetHomeDiscountProducts(this.limit, this.page, this.sort, this.language);

  @override
  List<Object> get props => [limit, page, sort, language];
}

class GetAllDiscountProducts extends DiscountEvent {
  final int limit;
  final int page;
  final String sort;

  final dynamic language;

  final bool isRefreshAll;

  const GetAllDiscountProducts(this.limit, this.page, this.sort, this.language, this.isRefreshAll);

  @override
  List<Object> get props => [limit, page, sort, language];
}

class AddToFavoriteDiscount extends DiscountEvent {
  final int productId;
  final int index;
  const AddToFavoriteDiscount(this.productId, this.index);

  @override
  List<Object> get props => [productId, index];
}

class ChangeSortDiscount extends DiscountEvent {
  const ChangeSortDiscount();

  @override
  List<Object> get props => [];
}