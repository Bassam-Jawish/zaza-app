
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/basket/data/models/product_unit.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/features/orders/data/models/order_details_model.dart';
import 'package:zaza_app/features/orders/data/models/order_model.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio) {
    return _OrderApiService(dio);
  }

  @GET('/order/user/')
  Future<HttpResponse<GeneralOrdersModel>> getOrders(
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('sort') String sort,
      @Query('status') String status,
      );

  @GET('/order/{order_id}')
  Future<HttpResponse<OrderDetailsModel>> getOrderDetails(
      @Path('order_id') int order_id,
      @Query('language')  language,
      );

  @POST('/order')
  Future<HttpResponse<void>> sendOrder(
      @Query('language')  language,
      @Body() List<ProductUnit> productUnitHelper,
      );

}