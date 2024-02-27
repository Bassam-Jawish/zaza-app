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
  List<Object?> get props => throw UnimplementedError();
}