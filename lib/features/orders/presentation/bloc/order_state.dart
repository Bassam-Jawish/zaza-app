part of 'order_bloc.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  error,
  changeStatusSearch,
  loadingOrder,
  successOrder,
  errorOrder,
}

class OrderState extends Equatable {
  final Failure? error;
  final List<GeneralOrderData>? ordersList;
  final GeneralOrdersEntity? generalOrdersEntity;
  final String? statusSearch;
  final OrderDetailsEntity? orderDetailsEntity;

  final OrderStatus? orderStatus;

  OrderState({
    this.error,
    this.ordersList,
    this.generalOrdersEntity,
    this.statusSearch,
    this.orderDetailsEntity,
    this.orderStatus
  });

  // CopyWith function for immutability
  OrderState copyWith({
    Failure? error,
    List<GeneralOrderData>? ordersList,
    GeneralOrdersEntity? generalOrdersEntity,
    String? statusSearch,
    OrderDetailsEntity? orderDetailsEntity,
    OrderStatus? orderStatus,
  }) {
    return OrderState(
      error: error ?? this.error,
      ordersList: ordersList ?? this.ordersList,
      generalOrdersEntity: generalOrdersEntity ?? this.generalOrdersEntity,
      statusSearch: statusSearch ?? this.statusSearch,
      orderDetailsEntity: orderDetailsEntity ?? this.orderDetailsEntity,
      orderStatus: orderStatus ?? this.orderStatus,

    );
  }

  @override
  List<Object?> get props => [
    error,
    ordersList,
    generalOrdersEntity,
    statusSearch,
    orderDetailsEntity,
  ];
}