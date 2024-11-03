// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDtoAdapter extends TypeAdapter<ProductDto> {
  @override
  final int typeId = 1;

  @override
  ProductDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDto(
      id: fields[0] as String,
      img_url: fields[1] as String?,
      name: fields[2] as String,
      price: fields[3] as double,
      stock: fields[4] as int,
      barCode: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.img_url)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.barCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
