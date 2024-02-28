import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final NetworkInfo _networkInfo;

  AuthBloc(this._loginUseCase, this._networkInfo)
      : super(AuthState().copyWith(authStatus: AuthStatus.initial, isPasswordVis: false)) {
    on<Login>(onLogin);
    on<ChangePassword>(onChangePassword);
  }

  void onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.error,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final loginParams =
          LoginParams(userName: event.userName, password: event.password);

      final dataState = await _loginUseCase(params: loginParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.success,
          accessToken: dataState.data!.accessToken!,
          refreshToken: dataState.data!.refreshToken!,
          userEntity: dataState.data!.userEntity!,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.error,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.error, error: ServerFailure.fromDioError(e)));
    }
  }

  void onChangePassword(ChangePassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        authStatus: AuthStatus.changePassword,
        isPasswordVis: !state.isPasswordVis!));
  }
}
