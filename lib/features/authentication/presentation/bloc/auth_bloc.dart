import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/validate_reset_password_usecase.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ValidateResetPasswordUseCase _validateResetPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  final NetworkInfo _networkInfo;

  AuthBloc(
      this._loginUseCase,
      this._forgotPasswordUseCase,
      this._validateResetPasswordUseCase,
      this._resetPasswordUseCase,
      this._logoutUseCase,
      this._networkInfo)
      : super(AuthState()
            .copyWith(authStatus: AuthStatus.initial, isPasswordVis: false)) {
    on<Login>(onLogin);
    on<ChangePassword>(onChangePassword);
    on<ForgotPassword>(onForgotPassword);
    on<ValidateResetPassword>(onValidateResetPassword);
    on<ResetPassword>(onResetPassword);
    on<Logout>(onLogout);
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

  void onForgotPassword(ForgotPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loadingForgotPass));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.errorForgotPass,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final forgotPassword = ForgotPasswordParams(email: event.email);

      final dataState = await _forgotPasswordUseCase(params: forgotPassword);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.successForgotPass,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorForgotPass,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorForgotPass,
          error: ServerFailure.fromDioError(e)));
    }
  }

  void onValidateResetPassword(
      ValidateResetPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loadingValidateResetPass));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.errorValidateResetPass,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final validateResetPasswordParams =
          ValidateResetPasswordParams(email: event.email, token: event.code);

      final dataState = await _validateResetPasswordUseCase(
          params: validateResetPasswordParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.successValidateResetPass,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorValidateResetPass,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorValidateResetPass,
          error: ServerFailure.fromDioError(e)));
    }
  }

  void onResetPassword(ResetPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loadingResetPass));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.errorValidateResetPass,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final resetPasswordParams = ResetPasswordParams(
          email: event.email, token: event.code, password: event.password);

      final dataState =
          await _resetPasswordUseCase(params: resetPasswordParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.successResetPass,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorResetPass,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorResetPass,
          error: ServerFailure.fromDioError(e)));
    }
  }

  void onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loadingLogout));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.errorLogout,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final dataState = await _logoutUseCase();

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.successLogout,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorLogout,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorLogout,
          error: ServerFailure.fromDioError(e)));
    }
  }
}
