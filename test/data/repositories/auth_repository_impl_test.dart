// auth_repository_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:zaza_app/core/resources/data_state.dart';
import 'package:zaza_app/features/authentication/data/data_sources/remote/auth_api_service.dart';
import 'package:zaza_app/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:zaza_app/features/authentication/domain/entities/user.dart';
import 'package:http/http.dart' as http;

import '../../helpers/json_reader.dart';

class MockAuthApiService extends Mock implements AuthApiService {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthApiService mockAuthApiService;

  setUp(() {
    mockAuthApiService = MockAuthApiService();
    authRepository = AuthRepositoryImpl(mockAuthApiService);
  });

  group('login', () {

    test('should return UserInfoEntity on successful login', () async {
      // Arrange
      final expectedUser = UserEntity(userId: 1, userName: 'example', name: 'Example User', email: 'example@example.com');
      final expectedUserInfo = UserInfoEntity(accessToken: 'access_token', refreshToken: 'refresh_token', userEntity: expectedUser);
      /*when(mockAuthApiService.login('', '')).thenAnswer((_) async => ();*/

      // Act
      final result = await authRepository.login('username', 'password');

      // Assert
      expect(result, isA<DataSuccess<UserInfoEntity>>());
      expect((result as DataSuccess<UserInfoEntity>).data, expectedUserInfo);
    });

    test('should return DataFailed on DioException', () async {
      // Arrange
      when(mockAuthApiService.login('beso', '12345678')).thenThrow(DioException(response: Response(statusCode: HttpStatus.badRequest, requestOptions: RequestOptions()), requestOptions: RequestOptions()));

      // Act
      final result = await authRepository.login('username', 'password');

      // Assert
      expect(result, isA<DataFailed>());
      expect((result as DataFailed).error, isA<DioError>());
    });

    // Add more test cases for other scenarios (e.g., invalid credentials, server errors, etc.)
  });
}
