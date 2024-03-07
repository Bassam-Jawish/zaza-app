import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/profile/domain/entities/user_profile.dart';
import 'package:zaza_app/features/profile/domain/usecases/create_phone_usecase.dart';
import 'package:zaza_app/features/profile/domain/usecases/delete_phone_usecase.dart';
import 'package:zaza_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/resources/data_state.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  final CreatePhoneUseCase _createPhoneUseCase;

  final DeletePhoneUseCase _deletePhoneUseCase;

  final NetworkInfo _networkInfo;

  ProfileBloc(this._getUserProfileUseCase, this._createPhoneUseCase,
      this._deletePhoneUseCase, this._networkInfo)
      : super(ProfileState().copyWith(
            profileStatus: ProfileStatus.initial,
            number: '',
            isoCode: '',
            isLoaded: false)) {
    on<GetUserProfile>(onGetUserProfile);
    on<CreatePhone>(onCreatePhone);
    on<DeletePhone>(onDeletePhone);
    on<AddingPhoneNumber>(onAddingPhoneNumber);
  }

  void onGetUserProfile(
      GetUserProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          profileStatus: ProfileStatus.error));
      return;
    }

    try {
      final userProfileParams = UserProfileParams(language: event.language);

      final dataState = await _getUserProfileUseCase(params: userProfileParams);

      print(dataState.data!.phonesList);
      if (dataState is DataSuccess) {
        emit(state.copyWith(
          userProfileEntity: dataState.data,
          profileStatus: ProfileStatus.success,
          isLoaded: true,
        ));
      }


      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            profileStatus: ProfileStatus.error));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          profileStatus: ProfileStatus.error));
    }
  }

  void onCreatePhone(CreatePhone event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loadingCreatePhone));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          profileStatus: ProfileStatus.errorCreatePhone));
      return;
    }

    print(state.isoCode);
    print(state.number);

    try {
      final createPhoneUseCaseParams = CreatePhoneUseCaseParams(
        language: event.language,
        data: jsonEncode({
          "phoneNumbers": [
            {"code": state.isoCode, "number": state.number}
          ]
        }),
      );

      final dataState = await _createPhoneUseCase(params: createPhoneUseCaseParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          profileStatus: ProfileStatus.successCreatePhone,
        ));
        // call get user profile
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            profileStatus: ProfileStatus.errorCreatePhone));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          profileStatus: ProfileStatus.errorCreatePhone));
    }
  }

  void onDeletePhone(DeletePhone event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loadingDeletePhone));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
          error: ConnectionFailure('No Internet Connection'),
          profileStatus: ProfileStatus.errorDeletePhone));
      return;
    }

    try {
      final deletePhoneUseCaseParams = DeletePhoneUseCaseParams(
          phoneId: event.phoneId, language: event.language);

      final dataState =
          await _deletePhoneUseCase(params: deletePhoneUseCaseParams);

      state.userProfileEntity!.phonesList!.removeAt(event.index);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          userProfileEntity: state.userProfileEntity,
          profileStatus: ProfileStatus.successDeletePhone,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            error: ServerFailure.fromDioError(dataState.error!),
            profileStatus: ProfileStatus.errorDeletePhone));
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          error: ServerFailure.fromDioError(e),
          profileStatus: ProfileStatus.errorDeletePhone));
    }
  }

  void onAddingPhoneNumber(
      AddingPhoneNumber event, Emitter<ProfileState> emit) async {
    print('sdfjgff');
    emit(state.copyWith(number: event.phoneNumber, isoCode: event.isoCode));
  }
}
