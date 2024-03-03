import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';

abstract class FavoriteRepository {
  // API methods
  Future<DataState<ProductEntity>> getFavoriteProducts(int limit, int page, String sort, String search, String language);

  Future<DataState<void>> addToFavorite(int productId);
}
