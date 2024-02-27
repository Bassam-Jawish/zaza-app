import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';

abstract class BasketRepository {
  // API methods
  Future<DataState<ProductEntity>> getBasketProducts(int limit, int page, dynamic language, List<dynamic> idList);

  Future<DataState<void>> getIdQuantityForBasket();

  Future<DataState<void>> addToBasket(int product_unit_id, int quantity);

  Future<DataState<void>> editQuantityBasket(int product_unit_id, int quantity, int index);

  Future<DataState<void>> removeOneFromBasket(int index);

  Future<DataState<void>> deleteBasket();
}
