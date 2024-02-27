import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/discount_repo.dart';

class GetDiscountUseCase
    implements UseCase<DataState<ProductEntity>, DiscountParams> {
  final DiscountRepository discountRepository;

  GetDiscountUseCase(this.discountRepository);

  @override
  Future<DataState<ProductEntity>> call({DiscountParams? params}) {
    return discountRepository.getDiscountProducts(
        params!.limit, params.page, params.sort, params.language);
  }
}

class DiscountParams {
  final int limit;
  final int page;

  final String sort;
  final dynamic language;

  DiscountParams(
      {required this.limit,
      required this.page,
      required this.sort,
      required this.language});
}
