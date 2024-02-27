import 'package:hive/hive.dart';

part 'product_unit.g.dart';

@HiveType(typeId: 0)
class ProductUnit {
  @HiveField(0)
  final int product_unit_id;

  @HiveField(1)
  final int quantity;

  ProductUnit({required this.product_unit_id, required this.quantity});

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productUnitId'] = this.product_unit_id;
    data['amount'] = this.quantity;
    return data;
  }
}
