import '../../domain/entities/order_details.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    int? orderId,
    dynamic totalPrice,
    String? createdAt,
    String? status,
    List<ProductOrderModel>? productsOrderDetailsList,
  }) : super(
          orderId: orderId,
          totalPrice: totalPrice,
          createdAt: createdAt,
          status: status,
          productsOrderDetailsList: productsOrderDetailsList,
        );

  factory OrderDetailsModel.fromJson(Map<String, dynamic> map) {
    return OrderDetailsModel(
      orderId: map['id'] ?? 0,
      totalPrice: map['totalPrice'],
      createdAt: map['createdAt'] ?? "",
      status: map['status'] ?? "",
      productsOrderDetailsList: map['products'] != null
          ? List<ProductOrderModel>.from((map['products'] as List)
              .map((productOrder) => ProductOrderModel.fromJson(productOrder)))
          : null,
    );
  }
}

class ProductOrderModel extends ProductOrderEntity {
  const ProductOrderModel({
    String? image,
    String? barCode,
    String? productName,
    List<ProductUnitOrderModel>? productUnitsOrderDetailsList,
  }) : super(
          image: image,
          barCode: barCode,
          productName: productName,
          productUnitsOrderDetailsList: productUnitsOrderDetailsList,
        );

  factory ProductOrderModel.fromJson(Map<String, dynamic> map) {
    return ProductOrderModel(
      image: map['image'] ?? "",
      barCode: map['barCode'] ?? "",
      productName: map['translatedProduct'] ?? "",
      productUnitsOrderDetailsList: map['productUnit'] != null
          ? List<ProductUnitOrderModel>.from((map['productUnit'] as List)
              .map((unitOrder) => ProductUnitOrderModel.fromJson(unitOrder)))
          : null,
    );
  }
}

class ProductUnitOrderModel extends ProductUnitOrderEntity {
  const ProductUnitOrderModel({
    String? desc,
    UnitOrderModel? unitOrderModel,
    UnitDetailsOrderModel? unitDetailsOrderModel,
  }) : super(
          desc: desc,
          unitOrderModel: unitOrderModel,
          unitDetailsOrderModel: unitDetailsOrderModel,
        );

  factory ProductUnitOrderModel.fromJson(Map<String, dynamic> map) {
    return ProductUnitOrderModel(
      desc: map['translatedProductUnit'] ?? "",
      unitOrderModel:
          map['unit'] != null ? UnitOrderModel.fromJson(map['unit']) : null,
      unitDetailsOrderModel: map['productOrders'] != null
          ? UnitDetailsOrderModel.fromJson(map['productOrders'])
          : null,
    );
  }
}

class UnitOrderModel extends UnitOrderEntity {
  const UnitOrderModel({
    String? unitName,
  }) : super(
          unitName: unitName,
        );

  factory UnitOrderModel.fromJson(Map<String, dynamic> map) {
    return UnitOrderModel(
      unitName: map['translatedUnit'] ?? "",
    );
  }
}

class UnitDetailsOrderModel extends UnitDetailsOrderEntity {
  const UnitDetailsOrderModel({
    int? amount,
    dynamic totalPrice,
  }) : super(
          amount: amount,
          totalPrice: totalPrice,
        );

  factory UnitDetailsOrderModel.fromJson(Map<String, dynamic> map) {
    return UnitDetailsOrderModel(
      amount: map['amount'] ?? 0,
      totalPrice: map['totalPrice'],
    );
  }
}