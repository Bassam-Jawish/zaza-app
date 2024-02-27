import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';

abstract class DiscountRepository {
  // API methods
  Future<DataState<ProductEntity>> getDiscountProducts(int limit, int page, String sort, dynamic language);
}
