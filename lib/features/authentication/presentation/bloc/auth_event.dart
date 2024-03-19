part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class Login extends AuthEvent {
  final String userName;
  final String password;

  const Login(this.userName, this.password);

  @override
  List<Object> get props => [userName, password];
}

class ChangePassword extends AuthEvent{
  const ChangePassword();
  @override
  List<Object> get props => [];
}

class ForgotPassword extends AuthEvent {
  final String email;

  final bool isResend;

  const ForgotPassword(this.email, this.isResend);

  @override
  List<Object> get props => [email, isResend];
}


class ValidateResetPassword extends AuthEvent {
  final String email;
  final String code;


  const ValidateResetPassword(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}


class ResetPassword extends AuthEvent {
  final String email;
  final String code;
  final String password;

  const ResetPassword(this.email, this.code, this.password);

  @override
  List<Object> get props => [email, code, password];
}

class Logout extends AuthEvent {
  const Logout();

  @override
  List<Object> get props => [];
}

class DeleteAccount extends AuthEvent {
  const DeleteAccount();

  @override
  List<Object> get props => [];
}