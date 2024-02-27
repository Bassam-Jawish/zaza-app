part of 'basket_bloc.dart';

abstract class BasketEvent extends Equatable {
  const BasketEvent();
}

class GetBasketProducts extends BasketEvent {
  final int limit;
  final int page;
  final dynamic languageCode;
  final List<dynamic> idList;

  const GetBasketProducts(this.limit, this.page, this.languageCode,this.idList);

  @override
  List<Object> get props => [limit, page, languageCode, idList];
}
