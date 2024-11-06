// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketModelHiveAdapter extends TypeAdapter<TicketModelHive> {
  @override
  final int typeId = 4;

  @override
  TicketModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketModelHive(
      companyName: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TicketModelHive obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.companyName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
