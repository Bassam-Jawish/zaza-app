part of 'discount_bloc.dart';

enum DiscountStatus { initial, loading, success, error }

class DiscountState extends Equatable {
  final Failure? error;
  final ProductEntity? productEntity;
  final int? discountPaginationNumberSave;
  final int? discountCurrentIndex;
  final DiscountStatus? discountStatus;

  const DiscountState(
      {this.error,
      this.productEntity,
      this.discountPaginationNumberSave,
      this.discountCurrentIndex,
      this.discountStatus});

  DiscountState copyWith({
    Failure? error,
    ProductEntity? productEntity,
    int? discountPaginationNumberSave,
    int? discountCurrentIndex,
    DiscountStatus? discountStatus,
  }) =>
      DiscountState(
        error: error ?? this.error,
        productEntity: productEntity ?? this.productEntity,
        discountPaginationNumberSave:
            discountPaginationNumberSave ?? this.discountPaginationNumberSave,
        discountCurrentIndex: discountCurrentIndex ?? this.discountCurrentIndex,
        discountStatus: discountStatus ?? this.discountStatus,
      );

  @override
  List<Object?> get props => [
        error,
        productEntity,
        discountPaginationNumberSave,
        discountCurrentIndex,
        discountStatus
      ];
}
