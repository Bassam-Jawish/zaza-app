import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/profile/domain/entities/user_profile.dart';
import 'package:zaza_app/features/profile/domain/repository/profile_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetUserProfileUseCase
    implements UseCase<DataState<UserProfileEntity>, UserProfileParams> {
  final ProfileRepository profileRepository;

  GetUserProfileUseCase(this.profileRepository);

  @override
  Future<DataState<UserProfileEntity>> call({UserProfileParams? params}) {
    return profileRepository.getUserProfile(params!.language);
  }
}

class UserProfileParams {
  final dynamic language;

  UserProfileParams(
      {required this.language});
}
