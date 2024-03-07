import 'package:hive/hive.dart';
import 'package:zaza_app/features/basket/data/models/product_unit.dart';

import 'basket_database_service.dart';

class BasketLocalDatabaseServiceImpl implements BasketLocalDatabaseService {
  final Box<ProductUnit> box;

  BasketLocalDatabaseServiceImpl({
    required this.box,
  });

  @override
  Future<List<ProductUnit>> getIdQuantityForBasket() async {
    return box.values.toList();
  }

  @override
  Future<void> addToBasket({required int product_unit_id, required int quantity}) async {
    bool productExists = false;
    try {
      ProductUnit existingProduct = box.values.firstWhere(
        (product) => product.product_unit_id == product_unit_id,
      );
      productExists = true;
    } catch (e) {
      print('${e.toString()}');
      // No matching product found
      productExists = false;
    }

    if (productExists) {
      throw HiveError('cannot add again');
    }
    else {
      final product =
      ProductUnit(product_unit_id: product_unit_id, quantity: quantity);
      box.add(product);
    }
  }

  @override
  Future<void> editQuantityBasket(
      {required int product_unit_id,
      required int quantity,
      required int index}) async {
    final updatedProduct = ProductUnit(
      product_unit_id: product_unit_id,
      quantity: quantity,
    );
    return box.putAt(index, updatedProduct);
  }

  @override
  Future<void> removeOneFromBasket({required int index}) async {
    return box.deleteAt(index);
  }

  @override
  Future<void> deleteBasket() {
    return box.clear();
  }
}
