import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class AddToBasketUseCase
    implements UseCase<DataState<void>, AddToBasketParams> {
  final BasketRepository basketRepository;

  AddToBasketUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({AddToBasketParams? params}) {
    return basketRepository.addToBasket(
        params!.product_unit_id, params.quantity);
  }
}

class AddToBasketParams {
  final int product_unit_id;
  final int quantity;

  AddToBasketParams({required this.product_unit_id, required this.quantity});
}
