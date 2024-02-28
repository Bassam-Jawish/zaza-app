import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class ValidateResetPasswordUseCase
    implements UseCase<DataState<void>, ValidateResetPasswordParams> {
  final AuthRepository authRepository;

  ValidateResetPasswordUseCase(this.authRepository);

  @override
  Future<DataState<void>> call({ValidateResetPasswordParams? params}) {
    return authRepository.validateResetPassword(params!.email, params.token);
  }
}

class ValidateResetPasswordParams {
  final String email;

  final String token;

  ValidateResetPasswordParams({required this.email, required this.token});
}
