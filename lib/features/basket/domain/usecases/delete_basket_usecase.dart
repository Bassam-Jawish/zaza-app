import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/basket_repo.dart';

class DeleteBasketUseCase
    implements UseCase<DataState<void>, NoParams> {
  final BasketRepository basketRepository;

  DeleteBasketUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({NoParams? params}) {
    return basketRepository.deleteBasket();
  }
}