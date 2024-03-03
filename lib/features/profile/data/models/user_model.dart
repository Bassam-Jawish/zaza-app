import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    int? userId,
    String? userName,
    String? name,
    String? email,
    List<UserPhonesModel>? phonesList,
  }) : super(
    userId: userId,
    userName: userName,
    name: name,
    email: email,
    phonesList: phonesList,
  );

  factory UserProfileModel.fromJson(Map<String, dynamic> map) {
    return UserProfileModel(
      userId: map['id'] ?? 0,
      userName: map['userName'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phonesList: map['phones'] != null
          ? List<UserPhonesModel>.from((map['phones'] as List)
          .map((phone) => UserPhonesModel.fromJson(phone)))
          : [],
    );
  }
}

class UserPhonesModel extends UserPhonesEntity {
  const UserPhonesModel({
    int? phoneId,
    String? number,
    String? numberCode,
  }) : super(
    phoneId: phoneId,
    number: number,
    numberCode: numberCode,
  );

  factory UserPhonesModel.fromJson(Map<String, dynamic> map) {
    return UserPhonesModel(
      phoneId: map['id'] ?? 0,
      number: map['number'] ?? "",
      numberCode: map['code'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': phoneId,
      'number': number,
      'code': numberCode,
    };
  }
}