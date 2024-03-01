part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetHomeNewProducts extends ProductEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;

  final String language;

  const GetHomeNewProducts(
      this.limit, this.page, this.sort, this.search, this.language);

  @override
  List<Object> get props => [limit, page, sort, search, language];
}

class GetSearchBarcodeProducts extends ProductEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;

  final String language;

  const GetSearchBarcodeProducts(
      this.limit, this.page, this.sort, this.search, this.language);

  @override
  List<Object> get props => [limit, page, sort, search, language];
}

class GetSearchNameProducts extends ProductEvent {
  final int limit;
  final int page;
  final String sort;
  final String search;

  final String language;

  const GetSearchNameProducts(
      this.limit, this.page, this.sort, this.search, this.language);

  @override
  List<Object> get props => [limit, page, sort, search, language];
}

class GetProductProfile extends ProductEvent {
  final int productId;
  final String language;

  const GetProductProfile(this.productId, this.language);

  @override
  List<Object> get props => [productId, language];
}

class ChangeUnitIndex extends ProductEvent {
  final int index;

  const ChangeUnitIndex(this.index);

  @override
  List<Object> get props => [index];
}


class ScanBarcode extends ProductEvent {
  const ScanBarcode();

  @override
  List<Object> get props => [];
}