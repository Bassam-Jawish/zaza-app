
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/product/data/models/product_model.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio) {
    return _ProductApiService(dio);
  }

  @GET('/product/{productId}')
  Future<HttpResponse<ProductDataModel>> getProductInfo(
      @Path('productId')  int productId,
      @Query('language')  String language,
      );

  @GET('/product')
  Future<HttpResponse<ProductModel>> search(
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('sort') String sort,
      @Query('search') String search,
      @Query('language')  String language,
      );
}