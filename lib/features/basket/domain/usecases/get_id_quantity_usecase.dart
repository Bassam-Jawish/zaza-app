import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class GetIdQuantityBasketUseCase
    implements UseCase<DataState<void>, NoParams> {
  final BasketRepository basketRepository;

  GetIdQuantityBasketUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({NoParams? params}) {
    return basketRepository.getIdQuantityForBasket();
  }
}