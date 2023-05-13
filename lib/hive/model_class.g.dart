// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class transactionsAdapter extends TypeAdapter<transactions> {
  @override
  final int typeId = 0;

  @override
  transactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return transactions()
      ..transaction_name = fields[0] as String
      ..transaction_note = fields[1] as String
      ..transaction_amount = fields[2] as double
      ..transaction_date = fields[3] as DateTime
      ..isexpence = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, transactions obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.transaction_name)
      ..writeByte(1)
      ..write(obj.transaction_note)
      ..writeByte(2)
      ..write(obj.transaction_amount)
      ..writeByte(3)
      ..write(obj.transaction_date)
      ..writeByte(4)
      ..write(obj.isexpence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is transactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class futuretransactionsAdapter extends TypeAdapter<futuretransactions> {
  @override
  final int typeId = 1;

  @override
  futuretransactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return futuretransactions()
      ..transaction_name = fields[0] as String
      ..transaction_note = fields[1] as String
      ..transaction_amount = fields[2] as double
      ..transaction_date = fields[3] as DateTime
      ..isexpence = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, futuretransactions obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.transaction_name)
      ..writeByte(1)
      ..write(obj.transaction_note)
      ..writeByte(2)
      ..write(obj.transaction_amount)
      ..writeByte(3)
      ..write(obj.transaction_date)
      ..writeByte(4)
      ..write(obj.isexpence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is futuretransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
