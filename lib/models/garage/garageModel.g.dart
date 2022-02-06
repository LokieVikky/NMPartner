// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class garageModelHiveGen extends TypeAdapter<OurGarage> {
  @override
  final int typeId = 112;

  @override
  OurGarage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OurGarage(
      uid: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      establishedYear: fields[3] as String,
      aboutUs: fields[4] as String,
      status: fields[5] as bool,
      openTime: (fields[6] as Map)?.cast<dynamic, dynamic>(),
      closeTime: (fields[7] as Map)?.cast<dynamic, dynamic>(),
      images: (fields[8] as Map)?.cast<dynamic, dynamic>(),
      contacts: (fields[9] as Map)?.cast<dynamic, dynamic>(),
      address: (fields[10] as Map)?.cast<dynamic, dynamic>(),
      ownerDetails: fields[11] as OwnerDetailsModel,
      vehiclesServices: fields[12] as dynamic,
      satisfaction: fields[13] as double,
      distanceAway: fields[14] as String,
      products: (fields[15] as List)?.cast<MechanicServices>(),
    );
  }

  @override
  void write(BinaryWriter writer, OurGarage obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.establishedYear)
      ..writeByte(4)
      ..write(obj.aboutUs)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.openTime)
      ..writeByte(7)
      ..write(obj.closeTime)
      ..writeByte(8)
      ..write(obj.images)
      ..writeByte(9)
      ..write(obj.contacts)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.ownerDetails)
      ..writeByte(12)
      ..write(obj.vehiclesServices)
      ..writeByte(13)
      ..write(obj.satisfaction)
      ..writeByte(14)
      ..write(obj.distanceAway)
      ..writeByte(15)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is garageModelHiveGen &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
