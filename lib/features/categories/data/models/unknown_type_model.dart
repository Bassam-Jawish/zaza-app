import '../../domain/entities/unknown_type_entity.dart';

class UnknownChildModel extends UnknownChildEntity {
  const UnknownChildModel({
    int? id,
    int? itemsNumber,
    int? parentCategoryId,
    String? typeName,
    String? categoryParentName,
  }) : super(
    id: id,
    itemsNumber: itemsNumber,
    parentCategoryId: parentCategoryId,
    typeName: typeName,
    categoryParentName: categoryParentName,
  );

  factory UnknownChildModel.fromJson(Map<String, dynamic> map) {
    return UnknownChildModel(
      id: map['id'] ?? 0,
      itemsNumber: map['productsNumber'] ?? 0,
      parentCategoryId: map['parentCategoryId'] ?? 0,
      typeName: map['typeName'] ?? "",
      categoryParentName: map['translatedText'] ?? "",
    );
  }
}