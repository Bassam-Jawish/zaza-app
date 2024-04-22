import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:zaza_app/features/authentication/domain/usecases/validate_reset_password_usecase.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ValidateResetPasswordUseCase _validateResetPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  final DeleteAccountUseCase _deleteAccountUseCase;

  final NetworkInfo _networkInfo;

  AuthBloc(
      this._loginUseCase,
      this._forgotPasswordUseCase,
      this._validateResetPasswordUseCase,
      this._resetPasswordUseCase,
      this._logoutUseCase,
      this._deleteAccountUseCase,
      this._networkInfo)
      : super(AuthState().copyWith(
            authStatus: AuthStatus.initial,
            isPasswordVis: false,
            isForgotPasswordLoading: false,
            isValidateResetPasswordLoading: false,
            isResetPasswordLoading: false)) {
    on<Login>(onLogin);
    on<ChangePassword>(onChangePassword);
    on<ForgotPassword>(onForgotPassword);
    on<ValidateResetPassword>(onValidateResetPassword);
    on<ResetPassword>(onResetPassword);
    on<Logout>(onLogout);
    on<DeleteAccount>(onDeleteAccount);
  }

  void onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    print('sfdgfjgjhfd');
    print(event.userName);
    print(event.password);

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        authStatus: AuthStatus.error,
        error: ConnectionFailure('No Internet Connection'),
      ));
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
    emit(state.copyWith(
        authStatus: AuthStatus.loadingForgotPass,
        isForgotPasswordLoading: true));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        authStatus: AuthStatus.errorForgotPass,
        error: ConnectionFailure('No Internet Connection'),
        isForgotPasswordLoading: false,
      ));
      return;
    }

    try {
      final forgotPassword = ForgotPasswordParams(email: event.email);

      final dataState = await _forgotPasswordUseCase(params: forgotPassword);

      if (dataState is DataSuccess) {
        if (event.isResend) {
          emit(state.copyWith(
            authStatus: AuthStatus.successForgotPass,
            isForgotPasswordLoading: false,
            isResend: true,
          ));
        } else {
          emit(state.copyWith(
            authStatus: AuthStatus.successForgotPass,
            isForgotPasswordLoading: false,
            isResend: false,
          ));
        }
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
          authStatus: AuthStatus.errorForgotPass,
          error: ServerFailure.fromDioError(
            dataState.error!,
          ),
          isForgotPasswordLoading: false,
        ));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        authStatus: AuthStatus.errorForgotPass,
        error: ServerFailure.fromDioError(e),
        isForgotPasswordLoading: false,
      ));
    }
  }

  void onValidateResetPassword(
      ValidateResetPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        authStatus: AuthStatus.loadingValidateResetPass,
        isValidateResetPasswordLoading: true));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        authStatus: AuthStatus.errorValidateResetPass,
        error: ConnectionFailure('No Internet Connection'),
        isValidateResetPasswordLoading: false,
      ));
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
          isValidateResetPasswordLoading: false,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
          authStatus: AuthStatus.errorValidateResetPass,
          error: ServerFailure.fromDioError(dataState.error!),
          isValidateResetPasswordLoading: false,
        ));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        authStatus: AuthStatus.errorValidateResetPass,
        error: ServerFailure.fromDioError(e),
        isValidateResetPasswordLoading: false,
      ));
    }
  }

  void onResetPassword(ResetPassword event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
        authStatus: AuthStatus.loadingResetPass, isResetPasswordLoading: true));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        authStatus: AuthStatus.errorValidateResetPass,
        error: ConnectionFailure('No Internet Connection'),
        isResetPasswordLoading: false,
      ));
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
            isResetPasswordLoading: false));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorResetPass,
            error: ServerFailure.fromDioError(dataState.error!),
            isResetPasswordLoading: false));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorResetPass,
          error: ServerFailure.fromDioError(e),
          isResetPasswordLoading: false));
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
        await SecureStorage.deleteAllSecureData();
        final router = AppRouter.router;
        router.pushReplacement(AppRouter.kLoginPage);
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

  void onDeleteAccount(DeleteAccount event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loadingDeleteAccount));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          authStatus: AuthStatus.errorLogout,
          error: ConnectionFailure('No Internet Connection')));
      return;
    }

    try {
      final dataState = await _deleteAccountUseCase();

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          authStatus: AuthStatus.successDeleteAccount,
        ));
        await SecureStorage.deleteAllSecureData();
        final router = AppRouter.router;
        router.pushReplacement(AppRouter.kLoginPage);
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            authStatus: AuthStatus.errorDeleteAccount,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          authStatus: AuthStatus.errorDeleteAccount,
          error: ServerFailure.fromDioError(e)));
    }
  }

}
