
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:zaza_app/features/profile/data/models/user_model.dart';

part 'profile_api_service.g.dart';

@RestApi()
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio) {
    return _ProfileApiService(dio);
  }

  @GET('/auth/profile/')
  Future<HttpResponse<UserProfileModel>> getUserProfile(
      @Query('language') String languageCode,
      );

  @POST('/phone/')
  Future<HttpResponse<void>> createPhoneNumber(
      @Query('language') String languageCode,
      @Body() String data,
      );

  @DELETE('/phone/{phone_id}')
  Future<HttpResponse<void>> deletePhoneNumber(
      @Path('phone_id') int phone_id,
      @Query('language') String languageCode,
      );
}

/*
UserPhonesModel userPhonesModel = UserPhonesModel(
  phoneId: 123,
  number: "1234567890",
  numberCode: "+1",
);

* Map<String, dynamic> requestData = {
  "phoneNumbers": [
    userPhonesModel.toJson(),
  ],
};
*
* */