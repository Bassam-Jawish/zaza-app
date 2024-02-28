
import 'package:dio/dio.dart';

import '../../models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) {
    return _AuthApiService(dio);
  }

  @POST('/auth/login')
  Future<HttpResponse<UserInfoModel>> login(
      @Field("userName") String userName,
      @Field("password") String password,
      );

  @POST('/user/forgot-password')
  Future<HttpResponse<void>> forgotPassword(
      @Field("email") String email,
      );

  @POST('/user/validate-token')
  Future<HttpResponse<void>> validateResetPassword(
      @Field("email") String email,
      @Field("token") String token,
      );

  @POST('/user/reset-password')
  Future<HttpResponse<void>> resetPassword(
      @Field("email") String email,
      @Field("token") String token,
      @Field("password") String password,
      );
}