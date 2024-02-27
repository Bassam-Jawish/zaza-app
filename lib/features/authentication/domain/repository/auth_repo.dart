import '../../../../core/resources/data_state.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // API methods
  Future<DataState<UserInfoEntity>> login(String userName, String password);
}
