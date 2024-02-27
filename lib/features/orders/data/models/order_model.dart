import '../../domain/entities/order.dart';

class GeneralOrdersModel extends GeneralOrdersEntity {
  const GeneralOrdersModel({
    int? totalOrders,
    List<GeneralOrderDataModel>? ordersList,
  }) : super(totalOrders: totalOrders, ordersList: ordersList);

  factory GeneralOrdersModel.fromJson(Map<String, dynamic> map) {
    return GeneralOrdersModel(
      totalOrders: map['count'] ?? 0,
      ordersList: map['orders'] != null
          ? List<GeneralOrderDataModel>.from((map['orders'] as List)
          .map((order) => GeneralOrderDataModel.fromJson(order)))
          : null,
    );
  }
}

class GeneralOrderDataModel extends GeneralOrderData {
  const GeneralOrderDataModel({
    int? orderId,
    dynamic totalPrice,
    String? createdAt,
    String? status,
  }) : super(
    orderId: orderId,
    totalPrice: totalPrice,
    createdAt: createdAt,
    status: status,
  );

  factory GeneralOrderDataModel.fromJson(Map<String, dynamic> map) {
    return GeneralOrderDataModel(
      orderId: map['id'] ?? 0,
      totalPrice: map['totalPrice'],
      createdAt: map['createdAt'] ?? "",
      status: map['status'] ?? "",
    );
  }
}