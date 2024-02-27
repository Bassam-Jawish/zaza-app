import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    int? id,
    int? itemsNumber,
    int? parentCategoryId,
    String? typeName,
    String? categoryName,
    String? image,
  }) : super(
    id: id,
    itemsNumber: itemsNumber,
    parentCategoryId: parentCategoryId,
    typeName: typeName,
    categoryName: categoryName,
    image: image,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      itemsNumber: map['productsNumber'] ?? 0,
      parentCategoryId: map['parentCategoryId'] ?? 0,
      typeName: (map['typeName'] ?? map['type']) ?? "",
      categoryName: map['translatedText'] ?? "",
      image: map['image'] ?? "",
    );
  }
}