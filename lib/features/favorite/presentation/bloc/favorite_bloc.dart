import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/features/favorite/domain/usecases/add_to_favorites_usecase.dart';
import 'package:zaza_app/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final NetworkInfo _networkInfo;

  FavoriteBloc(this._getFavoritesUseCase, this._addToFavoritesUseCase, this._networkInfo)
      : super(
      FavoriteState().copyWith(favoriteStatus: FavoriteStatus.initial)) {
    on<GetFavoriteProducts>(onGetFavoriteProducts);
    on<AddToFavorite>(onAddToFavorite);
  }

  void onGetFavoriteProducts(
      GetFavoriteProducts event, Emitter<FavoriteState> emit) async {



  }

  void onAddToFavorite(
      AddToFavorite event, Emitter<FavoriteState> emit) async {



  }

}
