import 'package:zaza_app/features/categories/domain/entities/category_entity.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

class CategoryParentEntity {
  final int? id;
  final int? parentCategoryId;
  final String? typeName;
  final String? categoryParentName;
  final int? totalNumber;
  final List<CategoryEntity>? categoriesChildren;
  final List<ProductEntity>? productsChildren;

  const CategoryParentEntity(
      {this.id,
      this.parentCategoryId,
      this.typeName,
      this.categoryParentName,
      this.totalNumber,
      this.categoriesChildren,
      this.productsChildren});

  @override
  List<Object?> get props => [
        id,
        parentCategoryId,
        typeName,
        categoryParentName,
        totalNumber,
        categoriesChildren,
        productsChildren
      ];
}
