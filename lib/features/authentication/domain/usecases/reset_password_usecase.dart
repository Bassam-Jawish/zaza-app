import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class ResetPasswordUseCase
    implements UseCase<DataState<void>, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPasswordUseCase(this.authRepository);

  @override
  Future<DataState<void>> call({ResetPasswordParams? params}) {
    return authRepository.resetPassword(
        params!.email, params.token, params.password);
  }
}

class ResetPasswordParams {
  final String email;

  final String token;

  final String password;

  ResetPasswordParams(
      {required this.email, required this.token, required this.password});
}
