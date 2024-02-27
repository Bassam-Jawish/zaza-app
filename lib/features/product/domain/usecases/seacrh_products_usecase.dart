import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/product/domain/repository/product_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class SearchProductsUseCase
    implements UseCase<DataState<ProductEntity>, SearchProductsParams> {
  final ProductRepository productRepository;

  SearchProductsUseCase(this.productRepository);

  @override
  Future<DataState<ProductEntity>> call({SearchProductsParams? params}) {
    return productRepository.searchProducts(params!.limit, params.page,
        params.sort, params.search, params.language);
  }
}

class SearchProductsParams {
  final int limit;
  final int page;

  final String sort;

  final String search;

  final dynamic language;

  SearchProductsParams({
    required this.limit,
    required this.page,
    required this.sort,
    required this.search,
    required this.language,
  });
}
