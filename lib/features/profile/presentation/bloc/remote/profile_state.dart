part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  error,
  loadingCreatePhone,
  successCreatePhone,
  errorCreatePhone,
  loadingDeletePhone,
  successDeletePhone,
  errorDeletePhone,
}

class ProfileState extends Equatable {
  final Failure? error;
  final UserProfileEntity? userProfileEntity;
  final ProfileStatus? profileStatus;

  final String? number;

  final String? isoCode;

  ProfileState({
    this.error,
    this.userProfileEntity,
    this.profileStatus,
    this.number,
    this.isoCode,
  });

  // CopyWith function for immutability
  ProfileState copyWith({
    Failure? error,
    UserProfileEntity? userProfileEntity,
    ProfileStatus? profileStatus,
    String? number,
    String? isoCode,
  }) {
    return ProfileState(
      error: error ?? this.error,
      userProfileEntity: userProfileEntity ?? this.userProfileEntity,
      profileStatus: profileStatus ?? this.profileStatus,
      number: number ?? this.number,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  List<Object?> get props => [
        error,
        userProfileEntity,
        profileStatus,
        number,
        isoCode,
      ];
}
