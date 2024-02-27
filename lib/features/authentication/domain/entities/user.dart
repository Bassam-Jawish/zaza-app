import 'dart:io';

import 'package:equatable/equatable.dart';


class UserInfoEntity extends Equatable {
  final String? accessToken;

  final String? refreshToken;

  final UserEntity? userEntity;

  const UserInfoEntity({this.accessToken,this.refreshToken, this.userEntity,});

  @override
  List<Object?> get props => [accessToken,refreshToken,userEntity];
}

class UserEntity extends Equatable {
  final int? userId;
  final String? userName;
  final String? name;
  final String? email;

  const UserEntity({this.userId, this.userName, this.name, this.email});

  @override
  List<Object?> get props => [userId, userName, name ,email];
}