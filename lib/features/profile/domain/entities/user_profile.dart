import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final int? userId;
  final String? userName;
  final String? name;
  final String? email;
  final List<UserPhonesEntity>? phonesList;

  const UserProfileEntity({
    this.userId,
    this.userName,
    this.name,
    this.email,
    this.phonesList,
  });

  @override
  List<Object?> get props => [userId, userName, name, email, phonesList];
}

class UserPhonesEntity extends Equatable {
  final int? phoneId;
  final String? number;
  final String? numberCode;

  const UserPhonesEntity({this.phoneId, this.number, this.numberCode});

  @override
  List<Object?> get props => [phoneId, number, numberCode];
}