import 'package:zaza_app/features/categories/domain/entities/choose_type_entity.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/category_repo.dart';

class GetCategoriesUseCase
    implements UseCase<DataState<dynamic>, CategoryParams> {
  final CategoryRepository categoryRepository;

  GetCategoriesUseCase(this.categoryRepository);

  @override
  Future<DataState<dynamic>> call({CategoryParams? params}) {
    return categoryRepository.getCategoryChildren(params!.id, params.limit, params.page, params.language);
  }
}

class CategoryParams {
  final dynamic id;
  final int limit;
  final int page;
  final dynamic language;

  CategoryParams(
      {required this.id,
      required this.limit,
      required this.page,
      required this.language});
}
