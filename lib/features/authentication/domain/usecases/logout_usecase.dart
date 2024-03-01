import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class LogoutUseCase implements UseCase<DataState<void>, NoParams> {
  final AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  @override
  Future<DataState<void>> call({NoParams? params}) {
    return authRepository.logout();
  }
}
