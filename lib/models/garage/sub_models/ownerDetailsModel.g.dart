// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownerDetailsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnerDetailsModelHiveGen extends TypeAdapter<OwnerDetailsModel> {
  @override
  final int typeId = 111;

  @override
  OwnerDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OwnerDetailsModel(
      title: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      gender: fields[3] as String,
      age: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OwnerDetailsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerDetailsModelHiveGen &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
