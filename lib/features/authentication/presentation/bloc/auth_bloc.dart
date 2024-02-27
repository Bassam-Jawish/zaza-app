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
  AuthBloc(this._loginUseCase, this._networkInfo) : super(const AuthInitial(false, false)) {
    on<Login>(onLogin);
    on<ChangePassword>(onChangePassword);
  }

  void onLogin(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading(state.isPasswordVis!, true));
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(AuthError(state.isPasswordVis!,
          const ConnectionFailure('No Internet Connection'), false));
      return;
    }

    try {
      final loginParams =
      LoginParams(userName: event.userName, password: event.password);

      final dataState = await _loginUseCase(params: loginParams);

      if (dataState is DataSuccess) {
        emit(
          AuthSuccess(
            state.isPasswordVis!,
            dataState.data!.accessToken!,
            dataState.data!.refreshToken!,
            dataState.data!.userEntity!,
            false,
          ),
        );
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(AuthError(state.isPasswordVis!,
            ServerFailure.fromDioError(dataState.error!), false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(AuthError(state.isPasswordVis!,
          ServerFailure.fromDioError(e), false));
    }
  }

  void onChangePassword(ChangePassword event, Emitter<AuthState> emit) async {
    emit(ChangePasswordState(
         !state.isPasswordVis!, state.isLoading!));
  }

}
