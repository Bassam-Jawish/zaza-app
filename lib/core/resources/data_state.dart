import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

abstract class DataState<T> {
  final T ? data;
  final DioException ? error;

  final HiveError? hiveError;

  const DataState({this.data, this.error, this.hiveError});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException error) : super(error: error);
}

class DataFailed2<T> extends DataState<T> {
  const DataFailed2(HiveError hiveError) : super(hiveError: hiveError);
}