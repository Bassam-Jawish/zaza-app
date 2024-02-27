import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final int? itemsNumber;
  final int? parentCategoryId;
  final String? typeName;
  final String? categoryName;
  final String? image;


  const CategoryEntity({this.id, this.itemsNumber,this.parentCategoryId,this.typeName, this.categoryName, this.image});

  @override
  List<Object?> get props => [id, itemsNumber, parentCategoryId, typeName, categoryName, image];
}