import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/authentication/domain/usecases/delete_account_usecase.dart';

@GenerateMocks(
  [
    AuthRepository,
    AuthApiService,
    LoginUseCase,
    ForgotPasswordUseCase,
    ValidateResetPasswordUseCase,
    ResetPasswordUseCase,
    LogoutUseCase,
    DeleteAccountUseCase,
    NetworkInfo
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)

void main() {}