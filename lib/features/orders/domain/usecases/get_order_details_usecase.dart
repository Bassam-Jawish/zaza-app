import 'package:zaza_app/features/orders/domain/entities/order_details.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/order_repo.dart';

class GetOrderDetailsUseCase
    implements UseCase<DataState<OrderDetailsEntity>, OrderDetailsParams> {
  final OrderRepository orderRepository;

  GetOrderDetailsUseCase(this.orderRepository);

  @override
  Future<DataState<OrderDetailsEntity>> call({OrderDetailsParams? params}) {
    return orderRepository.getOrderDetails(params!.orderId, params.language);
  }
}

class OrderDetailsParams {
  final int orderId;
  final dynamic language;

  OrderDetailsParams({required this.orderId, required this.language});
}
