import '../../domain/entities/choose_type_entity.dart';

class ChooseTypeModel extends ChooseTypeEntity {
  const ChooseTypeModel({
    int? catId,
    String? typeName,
    int? totalNumber,
  }) : super(
    catId: catId,
    typeName: typeName,
    totalNumber: totalNumber,
  );

  factory ChooseTypeModel.fromJson(Map<String, dynamic> map) {
    return ChooseTypeModel(
      catId: map['id'] ?? 0,
      typeName: map['typeName'] ?? "",
      totalNumber: map['count'] ?? 0,
    );
  }
}