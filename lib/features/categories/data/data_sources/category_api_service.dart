
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/categories/data/models/choose_type_model.dart';
import 'package:zaza_app/injection_container.dart';

part 'category_api_service.g.dart';

@RestApi()
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio) {
    return _CategoryApiService(dio);
  }

  @GET('/category/{id}')
  Future<HttpResponse<dynamic>> getCategoryChildren(
      @Path('id') dynamic id,
      @Query('limit') int limit,
      @Query('page') int page,
      @Query('language') String languageCode,
      );
}