import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:retrofit/dio.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/authentication/data/models/user_model.dart';
import 'package:zaza_app/injection_container.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late Dio dio;
  late MockHttpClient mockHttpClient;
  late AuthApiService authApiService;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'language': languageCode,
        },
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    authApiService = AuthApiService(dio);
  });

  const userName = 'beso';
  const password = '12345678';

  group('login', () {
    test('should return user info model when the response code is 200 or 201',
        () async {
      //arrange
      when(mockHttpClient.post(Uri.parse('${baseUrl}/auth/login'),
              body: {'userName': userName, 'password': password}))
          .thenAnswer((_) async => http.Response(
              readJson('helpers/dummy_data/dummy_login_response.json'), 200));

      //act
      final Future<HttpResponse<UserInfoModel>> resultSuccess = authApiService.login(userName, password);

      //assert
      final result = await resultSuccess;
      expect(result, isA<HttpResponse<UserInfoModel>>());
    });

    test(
      'should throw a server exception when the response code is 404 or other',
          () async {
        //arrange
        when(
          mockHttpClient.post(Uri.parse('${baseUrl}/auth/login'),
              body: {'userName': userName, 'password': password}),
        ).thenAnswer((_) async => http.Response('Not found', 404));

        //act
        final Future<HttpResponse<UserInfoModel>> resultFuture = authApiService.login(userName, password);

        //assert
        final result = await resultFuture;
        expect(result, isA<HttpResponse<UserInfoModel>>());
      },
    );
  });
}
