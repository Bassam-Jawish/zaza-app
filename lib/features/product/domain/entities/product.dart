import 'dart:io';

import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? totalNumber;

  final List<ProductData>? productList;

  const ProductEntity({this.totalNumber, this.productList});

  @override
  List<Object?> get props => [totalNumber, productList];
}

class ProductData extends Equatable {
  final int? productId;
  final String? image;
  final int? discount;
  final String? productName;
  final bool? isFavorite;
  final dynamic barCode;
  final String? taxName;
  final int? taxPercent;
  final List<ProductUnit>? productUnitListModel;

  const ProductData(
      {this.productId,
      this.image,
      this.discount,
      this.productName,
      this.isFavorite,
      this.barCode,
      this.taxName,
      this.taxPercent,
      this.productUnitListModel});

  @override
  List<Object?> get props => [
        productId,
        image,
        discount,
        productName,
        isFavorite,
        taxName,
        taxPercent,
        productUnitListModel
      ];
}

class ProductUnit extends Equatable {
  final int? productUnitId;
  final int? unitId;
  final int? quantity;
  final String? unitName;
  final String? description;
  final dynamic price;

  const ProductUnit(
      {this.productUnitId,
      this.unitId,
      this.quantity,
      this.unitName,
      this.description,
      this.price});

  @override
  List<Object?> get props =>
      [productUnitId, unitId, quantity, unitName, description, price];
}
