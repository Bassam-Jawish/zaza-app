
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class LoginUseCase implements UseCase<DataState<UserInfoEntity>, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  @override
  Future<DataState<UserInfoEntity>> call({LoginParams? params}) {
    return authRepository.login(params!.userName, params.password);
  }

}

class LoginParams {
  final String userName;
  final String password;

  LoginParams({required this.userName, required this.password});
}