
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/basket/data/models/product_unit.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/features/orders/data/models/order_details_model.dart';
import 'package:zaza_app/features/orders/data/models/order_model.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';

part 'favorite_api_service.g.dart';

@RestApi()
abstract class FavoriteApiService {
  factory FavoriteApiService(Dio dio) {
    return _FavoriteApiService(dio);
  }

  @GET('/favorite-product')
  Future<HttpResponse<ProductModel>> getFavoriteProducts(
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('sort') String sort,
      @Query('search') String search,
      @Query('status') String status,
      );

  @POST('/favorite-product/{productId}')
  Future<HttpResponse<void>> addToFavorite(
      @Path('productId') int productId,
      );

}