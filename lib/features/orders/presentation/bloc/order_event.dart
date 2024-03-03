part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class GetProfileOrders extends OrderEvent {
  final int limit;
  final int page;
  final String sort;
  final String status;

  const GetProfileOrders(this.limit, this.page, this.sort, this.status);

  @override
  List<Object> get props => [limit, page, sort, status];
}


class GetOrders extends OrderEvent {
  final int limit;
  final int page;
  final String sort;
  final String status;

  const GetOrders(this.limit, this.page, this.sort, this.status);

  @override
  List<Object> get props => [limit, page, sort, status];
}


class GetOrderDetails extends OrderEvent {
  final int orderId;

  const GetOrderDetails(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class ChangeDropdownValue extends OrderEvent {
  final String val;

  const ChangeDropdownValue(this.val);

  @override
  List<Object> get props => [val];
}