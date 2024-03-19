import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zaza_app/core/error/failure.dart';
import 'package:zaza_app/core/resources/data_state.dart';
import 'package:zaza_app/features/authentication/domain/entities/user.dart';
import 'package:zaza_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:zaza_app/features/authentication/presentation/bloc/auth_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockValidateResetPasswordUseCase mockValidateResetPasswordUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockValidateResetPasswordUseCase = MockValidateResetPasswordUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockNetworkInfo = MockNetworkInfo();
    authBloc = AuthBloc(
        mockLoginUseCase,
        mockForgotPasswordUseCase,
        mockValidateResetPasswordUseCase,
        mockResetPasswordUseCase,
        mockLogoutUseCase,
        mockDeleteAccountUseCase,
        mockNetworkInfo);
  });

  const testUserName = 'testUser';
  const testPassword = 'testPassword';

  const testUserInfoEntity = UserInfoEntity(
    accessToken: 'accessToken',
    refreshToken: 'refreshToken',
    userEntity: UserEntity(
        userId: 1,
        userName: 'testUser',
        name: 'Test User',
        email: 'test@example.com'),
  );

  test('initial state should be initial', () {
    expect(
        authBloc.state,
        AuthState().copyWith(
            authStatus: AuthStatus.initial,
            isPasswordVis: false,
            isForgotPasswordLoading: false,
            isValidateResetPasswordLoading: false,
            isResetPasswordLoading: false));
  });

  blocTest<AuthBloc, AuthState>(
    'should emit [loading, success] when login is successful',
    build: () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockLoginUseCase(
              params:
                  LoginParams(userName: testUserName, password: testPassword)))
          .thenAnswer((_) async => DataSuccess(testUserInfoEntity));
      return authBloc;
    },
    act: (bloc) => bloc.add(Login(testUserName, testPassword)),
    expect: () => [
      AuthState().copyWith(
        authStatus: AuthStatus.loading,
        // Ensure all boolean fields are initialized to false
        isPasswordVis: false,
        isForgotPasswordLoading: false,
        isValidateResetPasswordLoading: false,
        isResetPasswordLoading: false,
      ),
      AuthState().copyWith(
        authStatus: AuthStatus.success,
        accessToken: testUserInfoEntity.accessToken,
        refreshToken: testUserInfoEntity.refreshToken,
        userEntity: testUserInfoEntity.userEntity,
        // Ensure all boolean fields are initialized to false
        isPasswordVis: false,
        isForgotPasswordLoading: false,
        isValidateResetPasswordLoading: false,
        isResetPasswordLoading: false,
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'should emit [loading, error] when login fails',
    build: () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockLoginUseCase(
              params:
                  LoginParams(userName: testUserName, password: testPassword)))
          .thenAnswer((_) async =>
              DataFailed(DioException(requestOptions: RequestOptions())));
      return authBloc;
    },
    act: (bloc) => bloc.add(Login(testUserName, testPassword)),
    expect: () => [
      AuthState().copyWith(authStatus: AuthStatus.loading),
      AuthState().copyWith(
          authStatus: AuthStatus.error, error: ServerFailure('Login failed')),
    ],
  );
}
