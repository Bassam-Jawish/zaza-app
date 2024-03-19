import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zaza_app/features/authentication/data/models/user_model.dart';
import 'package:zaza_app/features/authentication/domain/entities/user.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testUserInfoModel = UserInfoModel(
    accessToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjMsInVzZXJuYW1lIjoiYmVzbyIsImlhdCI6MTcxMDUyMTE2OCwiZXhwIjoxNzEwNTIyOTY4fQ.nJeakbMZXfiDZz9wJfcvFsehRSL2ar81QG8vZEgd5bM',
    refreshToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjMsInVzZXJuYW1lIjoiYmVzbyIsImlhdCI6MTcxMDUyMTE2OCwiZXhwIjoxNzExMzg1MTY4fQ.035hreO08mHaHV1nNd0PZ9O6f7Lr1NyxL86GOphGwYU',
    user: User(
      userId: 3,
      userName: 'beso',
      name: 'Jawisho',
      email: 'jawishbassam@gmail.com',
    ),
  );

  test('should be a subclass of user info entity', () async {
    //assert
    expect(testUserInfoModel, isA<UserInfoEntity>());
  });

  test('should return a valid model from json', () async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_data/dummy_login_response.json'),
    );

    //act
    final result = UserInfoModel.fromJson(jsonMap);

    //assert
    expect(result, equals(testUserInfoModel));
  });

  test(
    'should return a json map containing proper data',
    () async {
      // act
      final result = testUserInfoModel.toJson();

      // assert
      final expectedJsonMap = {
        "accessToken":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjMsInVzZXJuYW1lIjoiYmVzbyIsImlhdCI6MTcxMDUyMTE2OCwiZXhwIjoxNzEwNTIyOTY4fQ.nJeakbMZXfiDZz9wJfcvFsehRSL2ar81QG8vZEgd5bM",
        "refreshToken":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjMsInVzZXJuYW1lIjoiYmVzbyIsImlhdCI6MTcxMDUyMTE2OCwiZXhwIjoxNzExMzg1MTY4fQ.035hreO08mHaHV1nNd0PZ9O6f7Lr1NyxL86GOphGwYU",
        "user": {
          "id": 3,
          "userName": "beso",
          "name": "Jawisho",
          "email": "jawishbassam@gmail.com",
        }
      };

      expect(result, equals(expectedJsonMap));
    },
  );
}
