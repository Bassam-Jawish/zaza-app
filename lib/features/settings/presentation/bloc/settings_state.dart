part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  changeLanguage
}

class SettingsState extends Equatable {
  final SettingsStatus? settingsStatus;

  final String? languageCode;

  SettingsState({
    this.settingsStatus,
    this.languageCode,
  });

  // CopyWith function for immutability
  SettingsState copyWith({
    SettingsStatus? settingsStatus,
    String? languageCode,
  }) {
    return SettingsState(
      settingsStatus: settingsStatus ?? this.settingsStatus,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [
    settingsStatus,
    languageCode,
  ];
}
