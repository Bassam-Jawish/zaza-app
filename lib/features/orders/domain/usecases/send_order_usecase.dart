import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../basket/data/models/product_unit.dart';
import '../entities/order.dart';
import '../repository/order_repo.dart';

class SendOrdersUseCase
    implements UseCase<DataState<void>, SendOrderParams> {
  final OrderRepository orderRepository;

  SendOrdersUseCase(this.orderRepository);

  @override
  Future<DataState<void>> call({SendOrderParams? params}) {
    return orderRepository.sendOrder(params!.language, params.productUnitHelper);
  }
}

class SendOrderParams {
  final dynamic language;

  final List<ProductUnit> productUnitHelper;

  SendOrderParams(
      {required this.language, required this.productUnitHelper});
}
