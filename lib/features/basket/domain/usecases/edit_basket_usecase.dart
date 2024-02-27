import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class EditQuantityBasketUseCase
    implements UseCase<DataState<void>, EditQuantityBasketParams> {
  final BasketRepository basketRepository;

  EditQuantityBasketUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({EditQuantityBasketParams? params}) {
    return basketRepository.editQuantityBasket(
        params!.product_unit_id, params.quantity, params.index);
  }
}

class EditQuantityBasketParams {
  final int product_unit_id;
  final int quantity;
  final int index;

  EditQuantityBasketParams(
      {required this.product_unit_id,
      required this.quantity,
      required this.index});
}
