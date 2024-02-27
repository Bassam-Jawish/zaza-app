import 'package:equatable/equatable.dart';

class GeneralOrdersEntity extends Equatable {
  final int? totalOrders;
  final List<GeneralOrderData>? ordersList;

  const GeneralOrdersEntity({this.totalOrders, this.ordersList});

  @override
  List<Object?> get props => [totalOrders, ordersList];
}

class GeneralOrderData extends Equatable {
  final int? orderId;
  final dynamic totalPrice;
  final String? createdAt;
  final String? status;

  const GeneralOrderData({this.orderId, this.totalPrice, this.createdAt, this.status});

  @override
  List<Object?> get props => [orderId, totalPrice, createdAt, status];
}