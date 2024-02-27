import 'package:equatable/equatable.dart';

class ChooseTypeEntity extends Equatable {
  final int? catId;
  final String? typeName;
  final int? totalNumber;
  const ChooseTypeEntity({this.catId, this.typeName, this.totalNumber});

  @override
  List<Object?> get props => [catId, typeName,totalNumber];
}