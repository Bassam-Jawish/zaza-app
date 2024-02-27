import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class GetBasketUseCase
    implements UseCase<DataState<ProductEntity>, BasketParams> {
  final BasketRepository basketRepository;

  GetBasketUseCase(this.basketRepository);

  @override
  Future<DataState<ProductEntity>> call({BasketParams? params}) {
    return basketRepository.getBasketProducts(
        params!.limit, params.page, params.language, params.idList);
  }
}

class BasketParams {
  final int limit;
  final int page;
  final dynamic language;
  final List<dynamic> idList;

  BasketParams(
      {required this.limit,
      required this.page,
      required this.language,
      required this.idList});
}
