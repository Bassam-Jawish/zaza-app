part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetUserProfile extends ProfileEvent {
  final String language;

  const GetUserProfile(this.language);

  @override
  List<Object> get props => [language];
}

class CreatePhone extends ProfileEvent {
  final String language;

  const CreatePhone(this.language);

  @override
  List<Object> get props => [language];
}

class DeletePhone extends ProfileEvent {
  final String language;

  final int phoneId;

  final int index;

  const DeletePhone(this.language, this.phoneId, this.index);

  @override
  List<Object> get props => [language, phoneId, index];
}
