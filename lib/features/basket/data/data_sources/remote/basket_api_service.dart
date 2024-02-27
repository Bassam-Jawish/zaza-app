
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

import '../../../../product/data/models/product_model.dart';

part 'basket_api_service.g.dart';

@RestApi()
abstract class BasketApiService {
  factory BasketApiService(Dio dio) {
    return _BasketApiService(dio);
  }

  @POST('/product/findAllByProductUnitIds/')
  Future<HttpResponse<ProductModel>> getBasketProducts(
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('language') languageCode,
      @Field("productUnitIds") List<dynamic> idList,
      );
}