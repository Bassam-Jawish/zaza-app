import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class ForgotPasswordUseCase
    implements UseCase<DataState<void>, ForgotPasswordParams> {
  final AuthRepository authRepository;

  ForgotPasswordUseCase(this.authRepository);

  @override
  Future<DataState<void>> call({ForgotPasswordParams? params}) {
    return authRepository.forgotPassword(params!.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}
