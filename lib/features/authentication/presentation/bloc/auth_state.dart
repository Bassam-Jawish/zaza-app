part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final UserEntity? userEntity;
  final Failure? error;
  final bool? isLoading;
  final bool? isPasswordVis;

  const AuthState(
      {this.accessToken,
      this.refreshToken,
      this.userEntity,
      this.error,
      this.isLoading,
      this.isPasswordVis});

  @override
  List<Object?> get props =>
      [accessToken, refreshToken, userEntity, error, isLoading, isPasswordVis];
}

class AuthInitial extends AuthState {
  const AuthInitial(bool isPasswordVis, bool isLoading)
      : super(isLoading: isLoading, isPasswordVis: isPasswordVis);
}

class AuthLoading extends AuthState {
  const AuthLoading(bool isPasswordVis, bool isLoading)
      : super(isPasswordVis: isPasswordVis, isLoading: isLoading);
}

class AuthSuccess extends AuthState {
  const AuthSuccess(bool isPasswordVis, String accessToken, String refreshToken,
      UserEntity userEntity, bool isLoading)
      : super(
            userEntity: userEntity,
            isLoading: isLoading,
            isPasswordVis: isPasswordVis);
}

class AuthError extends AuthState {
  const AuthError(bool isPasswordVis, Failure error, bool isLoading)
      : super(isPasswordVis: isPasswordVis, error: error, isLoading: isLoading);
}

class ChangePasswordState extends AuthState {
  const ChangePasswordState(bool isPasswordVis, bool isLoading)
      : super(isPasswordVis: isPasswordVis, isLoading: isLoading);
}
