// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sele_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleItemDtoAdapter extends TypeAdapter<SaleItemDto> {
  @override
  final int typeId = 3;

  @override
  SaleItemDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleItemDto(
      product: fields[0] as ProductDto,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SaleItemDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleItemDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleDtoAdapter extends TypeAdapter<SaleDto> {
  @override
  final int typeId = 2;

  @override
  SaleDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleDto(
      id: fields[1] as String,
      saleDate: fields[2] as DateTime,
      items: (fields[3] as List).cast<SaleItemDto>(),
      totalsale: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SaleDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.saleDate)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.totalsale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
