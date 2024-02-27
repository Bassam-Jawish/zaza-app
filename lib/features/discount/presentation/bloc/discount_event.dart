part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();
}

class GetDiscountProducts extends DiscountEvent {
  final int limit;
  final int page;
  final String sort;

  final dynamic language;

  const GetDiscountProducts(this.limit, this.page, this.sort, this.language);

  @override
  List<Object> get props => [limit, page, sort, language];
}
