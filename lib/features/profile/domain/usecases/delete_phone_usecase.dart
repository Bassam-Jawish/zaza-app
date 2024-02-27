import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/profile/domain/entities/user_profile.dart';
import 'package:zaza_app/features/profile/domain/repository/profile_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class DeletePhoneUseCase
    implements UseCase<DataState<void>, DeletePhoneUseCaseParams> {
  final ProfileRepository profileRepository;

  DeletePhoneUseCase(this.profileRepository);

  @override
  Future<DataState<void>> call({DeletePhoneUseCaseParams? params}) {
    return profileRepository.deletePhoneNumber(
        params!.phoneId, params.language);
  }
}

class DeletePhoneUseCaseParams {
  final int phoneId;
  final dynamic language;

  DeletePhoneUseCaseParams({required this.phoneId, required this.language});
}
