import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repository/order_repo.dart';

class GetOrdersUseCase
    implements UseCase<DataState<GeneralOrdersEntity>, OrderParams> {
  final OrderRepository orderRepository;

  GetOrdersUseCase(this.orderRepository);

  @override
  Future<DataState<GeneralOrdersEntity>> call({OrderParams? params}) {
    return orderRepository.getOrders(
        params!.limit, params!.page, params!.sort, params!.status);
  }
}

class OrderParams {
  final int limit;
  final int page;
  final String sort;
  final String status;

  OrderParams(
      {required this.limit,
      required this.page,
      required this.sort,
      required this.status});
}
