import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';

abstract class ProductRepository {
  // API methods
  Future<DataState<ProductData>> getProductInfo(
      int productId, dynamic language);

  Future<DataState<ProductEntity>> searchProducts(
      int limit, int page, String sort, String search, dynamic language);
}
