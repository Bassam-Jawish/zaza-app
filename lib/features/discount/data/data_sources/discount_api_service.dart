
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';

part 'discount_api_service.g.dart';

@RestApi()
abstract class DiscountApiService {
  factory DiscountApiService(Dio dio) {
    return _DiscountApiService(dio);
  }

  @GET('/discount')
  Future<HttpResponse<ProductModel>> getDiscountProducts(
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('sort') String sort,
      @Query('language')  language,
      );
}