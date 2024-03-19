import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/auth_repo.dart';

class DeleteAccountUseCase implements UseCase<DataState<void>, NoParams> {
  final AuthRepository authRepository;

  DeleteAccountUseCase(this.authRepository);

  @override
  Future<DataState<void>> call({NoParams? params}) {
    return authRepository.deleteAccount();
  }
}
