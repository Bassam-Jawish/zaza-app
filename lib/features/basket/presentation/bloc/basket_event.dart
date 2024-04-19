part of 'basket_bloc.dart';

abstract class BasketEvent extends Equatable {
  const BasketEvent();
}

class GetBasketProducts extends BasketEvent {
  final int limit;
  final int page;
  final dynamic languageCode;
  const GetBasketProducts(this.limit, this.page, this.languageCode);

  @override
  List<Object> get props => [limit, page, languageCode];
}

class ClearQuantityController extends BasketEvent {
  const ClearQuantityController();

  @override
  List<Object> get props => [];
}


class ChangeTextValue extends BasketEvent {

  String chosenQuantity;
  ChangeTextValue(this.chosenQuantity);
  @override
  List<Object> get props => [chosenQuantity];
}

class GetIdQuantityForBasket extends BasketEvent {

  const GetIdQuantityForBasket();

  @override
  List<Object> get props => [];
}


class AddToBasket extends BasketEvent {

  int productUnitId;

  int quantity;

  AddToBasket(this.productUnitId, this.quantity);

  @override
  List<Object> get props => [productUnitId, quantity];
}

class EditQuantityBasket extends BasketEvent {

  int productUnitId;

  int quantity;

  int index;

  EditQuantityBasket(this.productUnitId, this.quantity, this.index);

  @override
  List<Object> get props => [productUnitId, quantity, index];
}

class RemoveOneFromBasket extends BasketEvent {

  int index;

  RemoveOneFromBasket(this.index);

  @override
  List<Object> get props => [index];
}

class DeleteBasket extends BasketEvent {

  bool isLogout;
  DeleteBasket(this.isLogout);

  @override
  List<Object> get props => [isLogout];
}

class SendOrder extends BasketEvent {

  dynamic language;
  SendOrder(this.language);

  @override
  List<Object> get props => [language];
}