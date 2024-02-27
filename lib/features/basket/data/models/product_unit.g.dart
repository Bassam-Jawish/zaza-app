// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductUnitAdapter extends TypeAdapter<ProductUnit> {
  @override
  final int typeId = 0;

  @override
  ProductUnit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductUnit(
      product_unit_id: fields[0] as int,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductUnit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product_unit_id)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
