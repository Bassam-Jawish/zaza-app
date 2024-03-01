import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../product/domain/entities/product.dart';
import '../../data/models/product_unit.dart';
import '../repository/basket_repo.dart';

class SendOrdersUseCase
    implements UseCase<DataState<void>, SendOrderParams> {
  final BasketRepository basketRepository;

  SendOrdersUseCase(this.basketRepository);

  @override
  Future<DataState<void>> call({SendOrderParams? params}) {
    return basketRepository.sendOrder(params!.language, params.productUnitHelper);
  }
}

class SendOrderParams {
  final dynamic language;

  final List<ProductUnit> productUnitHelper;

  SendOrderParams(
      {required this.language, required this.productUnitHelper});
}
