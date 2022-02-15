// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_setup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataBaseSetupAdapter extends TypeAdapter<DataBaseSetup> {
  @override
  final int typeId = 0;

  @override
  DataBaseSetup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataBaseSetup()
      ..host = fields[0] as String
      ..port = fields[1] as int
      ..database = fields[2] as String
      ..username = fields[3] as String
      ..password = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, DataBaseSetup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.host)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.database)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataBaseSetupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
