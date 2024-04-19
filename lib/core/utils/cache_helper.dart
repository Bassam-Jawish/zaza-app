import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';

import '../../injection_container.dart';


class CacheHelper
{
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async
  {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is List<String>) return await sharedPreferences!.setStringList(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> remove({
    required String key,
  })async
  {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> clearShared()async
  {
    return await sharedPreferences!.clear();
  }

}

////////////////////////////////////////////////////////////////////////////////

class SecureStorage {

  static FlutterSecureStorage? storage;

  static initStorage()
  {
    storage = FlutterSecureStorage(aOptions: _secureOption());
  }

  static AndroidOptions _secureOption() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<void>writeSecureData({required String key, required dynamic value}) async {
    await storage!.write(key: key, value: value.toString(),);
  }

  static dynamic readSecureData({required String key}) async {
    String value = await storage!.read(key: key) ?? 'No data found!';
    print('Data read from secure storage: $value');
    return value;
  }

  static Future<void>deleteSecureData({required String key}) async {
    await storage!.delete(key: key);
  }

  static Future<void>deleteAllSecureData() async {
    await storage!.delete(key: 'token');
    await storage!.delete(key: 'refresh_token');
    await storage!.delete(key: 'user_id');
    await storage!.delete(key: 'user_name');
    token = 'No data found!';
    refresh_token = 'No data found!';
    user_id = 'No data found!';
    user_name = 'No data found!';
    categoryId = null;
    productId = null;
    productName = null;
    orderId = null;
    barcodeSearch = '';
    nameSearch = '';
  }
}