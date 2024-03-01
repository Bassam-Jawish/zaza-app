import '../../../../core/resources/data_state.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // API methods
  Future<DataState<UserInfoEntity>> login(String userName, String password);

  Future<DataState<void>> forgotPassword(String email);

  Future<DataState<void>> validateResetPassword(String email, String token);

  Future<DataState<void>> resetPassword(String email, String token, String password);

  Future<DataState<void>> logout();
}
