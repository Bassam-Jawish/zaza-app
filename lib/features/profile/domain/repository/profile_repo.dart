import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  // API methods

  Future<DataState<UserProfileEntity>> getUserProfile(
      String language);

  Future<DataState<void>> createPhoneNumber(
      String language, String data);

  Future<DataState<void>> deletePhoneNumber(
      int phoneId, String language);

}
