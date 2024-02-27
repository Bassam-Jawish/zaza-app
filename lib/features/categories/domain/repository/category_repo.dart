import '../../../../core/resources/data_state.dart';
import '../entities/choose_type_entity.dart';

abstract class CategoryRepository {
  // API methods
  Future<DataState<ChooseTypeEntity>> getCategoryChildren(
      int id, int limit, int page, dynamic language);
}
