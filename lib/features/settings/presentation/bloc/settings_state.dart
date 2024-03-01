part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  changeLanguage
}

class SettingsState extends Equatable {
  final SettingsStatus? settingsStatus;

  SettingsState({
    this.settingsStatus,
  });

  // CopyWith function for immutability
  SettingsState copyWith({
    SettingsStatus? settingsStatus,
  }) {
    return SettingsState(
      settingsStatus: settingsStatus ?? this.settingsStatus,
    );
  }

  @override
  List<Object?> get props => [
    settingsStatus,
  ];
}
