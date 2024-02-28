import '../../../product/data/models/product_model.dart';
import '../../domain/entities/category_parent_entity.dart';
import 'category_model.dart';

class CategoryParentModel extends CategoryParentEntity {
  const CategoryParentModel({
    int? id,
    int? parentCategoryId,
    String? typeName,
    String? categoryParentName,
    int? totalNumber,
    List<CategoryModel>? categoriesChildren,
    List<ProductDataModel>? productsChildren,
  }) : super(
    id: id,
    parentCategoryId: parentCategoryId,
    typeName: typeName,
    categoryParentName: categoryParentName,
    totalNumber: totalNumber,
    categoriesChildren: categoriesChildren,
    productsChildren: productsChildren,
  );

  factory CategoryParentModel.fromJson(Map<String, dynamic> map) {
    return CategoryParentModel(
      id: map['id'] ?? 0,
      parentCategoryId: map['parentCategoryId'] ?? 0,
      typeName: (map['typeName'] ?? map['type']) ?? "",
      categoryParentName: map['categoryParentName'] ?? "",
      totalNumber: map['count'] ?? 0,
      categoriesChildren: map['categories'] != null
          ? List<CategoryModel>.from((map['categories'] as List)
          .map((category) => CategoryModel.fromJson(category)))
          : [],
      productsChildren: map['translatedProducts'] != null
          ? List<ProductDataModel>.from((map['translatedProducts'] as List)
          .map((product) => ProductDataModel.fromJson(product)))
          : [],
    );
  }
}