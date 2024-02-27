import 'package:equatable/equatable.dart';

class UnknownChildEntity extends Equatable {
  final int? id;
  final int? itemsNumber;
  final int? parentCategoryId;
  final String? typeName;
  final String? categoryParentName;

  const UnknownChildEntity({this.id, this.itemsNumber, this.parentCategoryId, this.typeName, this.categoryParentName});
  @override
  List<Object?> get props => [id, itemsNumber, parentCategoryId, typeName, categoryParentName];
}