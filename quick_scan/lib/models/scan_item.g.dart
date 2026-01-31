// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanItemAdapter extends TypeAdapter<ScanItem> {
  @override
  final int typeId = 0;

  @override
  ScanItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanItem(
      code: fields[0] as String,
      format: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScanItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.format)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
