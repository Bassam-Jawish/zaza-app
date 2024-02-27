import 'package:zaza_app/features/product/domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    int? totalNumber,
    List<ProductDataModel>? productList,
  }) : super(totalNumber: totalNumber, productList: productList);

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      totalNumber: map['count'] ?? 0,
      productList: map['translatedProducts'] != null
          ? List<ProductDataModel>.from((map['translatedProducts'] as List)
              .map((product) => ProductDataModel.fromJson(product)))
          : null,
    );
  }
}

class ProductDataModel extends ProductData {
  const ProductDataModel({
    int? productId,
    String? image,
    int? discount,
    String? productName,
    bool? isFavorite,
    dynamic barCode,
    String? taxName,
    int? taxPercent,
    List<ProductUnitModel>? productUnitListModel,
  }) : super(
          productId: productId,
          image: image,
          discount: discount,
          productName: productName,
          isFavorite: isFavorite,
          barCode: barCode,
          taxName: taxName,
          taxPercent: taxPercent,
          productUnitListModel: productUnitListModel,
        );

  factory ProductDataModel.fromJson(Map<String, dynamic> map) {
    return ProductDataModel(
      productId: map['id'] ?? 0,
      image: map['image'] ?? "",
      discount: map['discount'] ?? 0,
      productName: map['translatedText'] ?? "",
      isFavorite: map['isFavorite'] ?? false,
      barCode: map['barCode'],
      taxName: map['translatedTaxPercent'] ?? "",
      taxPercent: map['taxPercent'] ?? 0,
      productUnitListModel: map['translatedProductUnits'] != null
          ? List<ProductUnitModel>.from((map['translatedProductUnits'] as List)
              .map((unit) => ProductUnitModel.fromJson(unit)))
          : null,
    );
  }
}

class ProductUnitModel extends ProductUnit {
  const ProductUnitModel({
    int? productUnitId,
    int? unitId,
    int? quantity,
    String? unitName,
    String? description,
    dynamic price,
  }) : super(
          productUnitId: productUnitId,
          unitId: unitId,
          quantity: quantity,
          unitName: unitName,
          description: description,
          price: price,
        );

  factory ProductUnitModel.fromJson(Map<String, dynamic> map) {
    return ProductUnitModel(
      productUnitId: map['id'] ?? 0,
      unitId: map['unitId'] ?? 0,
      quantity: map['quantity'] ?? 0,
      unitName: map['translatedUnitText'] ?? "",
      description: map['translatedText'] ?? "",
      price: map['price'],
    );
  }
}
