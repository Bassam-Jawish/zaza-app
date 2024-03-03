part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
  changePassword,
  loadingForgotPass,
  successForgotPass,
  errorForgotPass,
  loadingValidateResetPass,
  successValidateResetPass,
  errorValidateResetPass,
  loadingResetPass,
  successResetPass,
  errorResetPass,
  loadingLogout,
  successLogout,
  errorLogout,
}

class AuthState extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final UserEntity? userEntity;
  final Failure? error;
  final bool? isLoading;
  final bool? isPasswordVis;
  final AuthStatus? authStatus;
  final bool? isForgotPasswordLoading;
  final bool? isValidateResetPasswordLoading;
  final bool? isResetPasswordLoading;

  final bool? isResend;

  const AuthState(
      {this.accessToken,
      this.refreshToken,
      this.userEntity,
      this.error,
      this.isLoading,
      this.isPasswordVis,
      this.authStatus,
      this.isForgotPasswordLoading,
      this.isValidateResetPasswordLoading,
      this.isResetPasswordLoading,
      this.isResend});

  AuthState copyWith({
    String? accessToken,
    String? refreshToken,
    UserEntity? userEntity,
    Failure? error,
    bool? isLoading,
    bool? isPasswordVis,
    AuthStatus? authStatus,
    bool? isForgotPasswordLoading,
    bool? isValidateResetPasswordLoading,
    bool? isResetPasswordLoading,
    bool? isResend,
  }) =>
      AuthState(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        userEntity: userEntity ?? this.userEntity,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        isPasswordVis: isPasswordVis ?? this.isPasswordVis,
        authStatus: authStatus ?? this.authStatus,
        isForgotPasswordLoading:
            isForgotPasswordLoading ?? this.isForgotPasswordLoading,
        isValidateResetPasswordLoading: isValidateResetPasswordLoading ??
            this.isValidateResetPasswordLoading,
        isResetPasswordLoading:
            isResetPasswordLoading ?? this.isResetPasswordLoading,
        isResend: isResend ?? this.isResend,
      );

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        userEntity,
        error,
        isLoading,
        isPasswordVis,
        authStatus,
        isForgotPasswordLoading,
        isValidateResetPasswordLoading,
        isResetPasswordLoading,
        isResend,
      ];
}
