part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class ChangeLanguage extends SettingsEvent {

  dynamic value;

  ChangeLanguage(this.value);

  @override
  List<Object> get props => [value];
}
