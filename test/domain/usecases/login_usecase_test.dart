import 'package:mockito/mockito.dart';
import 'package:zaza_app/core/resources/data_state.dart';
import 'package:zaza_app/features/authentication/domain/entities/user.dart';
import 'package:zaza_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository!);
  });

  // Entity
  const testLoginEntity = UserInfoEntity(
    accessToken: 'specificAccessToken',
    refreshToken: 'specificRefreshToken',
    userEntity: UserEntity(
      userId: 123,
      userName: 'specificUserName',
      name: 'specificName',
      email: 'specificEmail@example.com',
    ),
  );

  // Params;
  const userName = 'beso';
  const password = '12345678';
  final LoginParams loginParams =
      LoginParams(userName: userName, password: password);

  test('should login', () async {
    // arrange

    when(mockAuthRepository!.login(userName, password)).thenAnswer(
        (realInvocation) async => const DataSuccess(testLoginEntity));

    // act

    final result = await loginUseCase?.call(params: loginParams);

    // assert

    expect(result, const DataSuccess(testLoginEntity));
  });
}
