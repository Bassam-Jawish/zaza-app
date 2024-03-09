import 'package:equatable/equatable.dart';

class OrderDetailsEntity extends Equatable {
  final int? orderId;
  final dynamic totalPrice;

  final dynamic totalPriceAfterTax;
  final String? createdAt;
  final String? status;
  final List<ProductOrderEntity>? productsOrderDetailsList;

  const OrderDetailsEntity({
    this.orderId,
    this.totalPrice,
    this.totalPriceAfterTax,
    this.createdAt,
    this.status,
    this.productsOrderDetailsList,
  });

  @override
  List<Object?> get props =>
      [orderId, totalPrice, totalPriceAfterTax, createdAt, status, productsOrderDetailsList];
}

class ProductOrderEntity extends Equatable {
  final String? image;
  final String? barCode;
  final String? productName;
  final List<ProductUnitOrderEntity>? productUnitsOrderDetailsList;

  const ProductOrderEntity({
    this.image,
    this.barCode,
    this.productName,
    this.productUnitsOrderDetailsList,
  });

  @override
  List<Object?> get props => [image, barCode, productName, productUnitsOrderDetailsList];
}

class ProductUnitOrderEntity extends Equatable {
  final String? desc;
  final UnitOrderEntity? unitOrderModel;
  final UnitDetailsOrderEntity? unitDetailsOrderModel;

  const ProductUnitOrderEntity({
    this.desc,
    this.unitOrderModel,
    this.unitDetailsOrderModel,
  });

  @override
  List<Object?> get props => [desc, unitOrderModel, unitDetailsOrderModel];
}

class UnitOrderEntity extends Equatable {
  final String? unitName;

  const UnitOrderEntity({this.unitName});

  @override
  List<Object?> get props => [unitName];
}

class UnitDetailsOrderEntity extends Equatable {
  final int? amount;
  final dynamic totalPrice;

  const UnitDetailsOrderEntity({this.amount, this.totalPrice});

  @override
  List<Object?> get props => [amount, totalPrice];
}