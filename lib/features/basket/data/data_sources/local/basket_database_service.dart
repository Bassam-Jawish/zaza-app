

import '../../models/product_unit.dart';

abstract class BasketLocalDatabaseService {
  Future<List<ProductUnit>> getIdQuantityForBasket();

  Future<void> addToBasket({required int product_unit_id, required int quantity});

  Future<void> editQuantityBasket({
    required int product_unit_id,
    required int quantity,
    required int index,
  });

  Future<void> removeOneFromBasket({required int index});

  Future<void> deleteBasket();
}
