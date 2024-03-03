import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/cache_helper.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/l10n.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(
            SettingsState().copyWith(settingsStatus: SettingsStatus.initial)) {
      on<ChangeLanguage>(onChangeLanguage);
  }

  void onChangeLanguage(
      ChangeLanguage event, Emitter<SettingsState> emit) async {
    selectedLanguageValue = event.value;

    if (!L10n.all.contains(locale)) return;

    if (event.value == 1) {
      locale = Locale('de');
      languageCode = 'de';
    } else if (event.value == 2) {
      locale = Locale('en');
      languageCode = 'en';
    } else {
      locale = Locale('ar');
      languageCode = 'ar';
    }
    print('locale=${locale}');
    print('languageCode=${languageCode}');

    await SecureStorage.writeSecureData(
      key: 'languageCode',
      value: languageCode,
    ).then((value) => debugPrint('success caching'));

    emit(state.copyWith(settingsStatus: SettingsStatus.changeLanguage,languageCode: languageCode));
  }
}
