
import '../../../../core/resources/data_state.dart';
import '../../../basket/data/models/product_unit.dart';
import '../entities/order.dart';
import '../entities/order_details.dart';

abstract class OrderRepository {
  // API methods
  Future<DataState<GeneralOrdersEntity>> getOrders(
      int limit, int page, String sort, String status);

  Future<DataState<OrderDetailsEntity>> getOrderDetails(
      int orderId, dynamic language);

  Future<DataState<void>> sendOrder(
      dynamic language,List<ProductUnit> productUnitHelper);
}
