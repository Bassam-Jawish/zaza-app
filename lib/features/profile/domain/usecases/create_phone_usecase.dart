import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/profile/domain/entities/user_profile.dart';
import 'package:zaza_app/features/profile/domain/repository/profile_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class CreatePhoneUseCase
    implements UseCase<DataState<void>, CreatePhoneUseCaseParams> {
  final ProfileRepository profileRepository;

  CreatePhoneUseCase(this.profileRepository);

  @override
  Future<DataState<void>> call({CreatePhoneUseCaseParams? params}) {
    return profileRepository.createPhoneNumber(params!.language, params.data);
  }
}

class CreatePhoneUseCaseParams {
  final dynamic language;

  final String data;

  CreatePhoneUseCaseParams({required this.language, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'data': data,
    };
  }
}
