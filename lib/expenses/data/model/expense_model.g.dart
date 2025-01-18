// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseModelHiveAdapter extends TypeAdapter<ExpenseModelHive> {
  @override
  final int typeId = 6;

  @override
  ExpenseModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseModelHive(
      id: fields[0] as int,
      amount: fields[1] as double,
      description: fields[2] as String,
      date: fields[3] as DateTime,
      category: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseModelHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
