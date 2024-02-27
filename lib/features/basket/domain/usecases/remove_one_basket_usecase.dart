import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class RemoveOneBasketUseCase
    implements UseCase<DataState<void>, RemoveOneBasketParams> {
  final BasketRepository basketRepository;

  RemoveOneBasketUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({RemoveOneBasketParams? params}) {
    return basketRepository.removeOneFromBasket(params!.index);
  }
}

class RemoveOneBasketParams {
  final int index;

  RemoveOneBasketParams({
    required this.index,
  });
}
