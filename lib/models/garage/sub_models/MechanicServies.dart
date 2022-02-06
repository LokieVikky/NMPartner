
import 'package:hive/hive.dart';

part 'MechanicServies.g.dart';
@HiveType(typeId: 123, adapterName: 'MechanicServiesHiveGen')

class MechanicServices{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int price;

  @HiveField(2)
  final String id;

  @HiveField(3)
  bool selected;
  MechanicServices({this.name, this.price, this.id, this.selected});


  factory MechanicServices.fromJSON(Map<String, dynamic> json) {
    return MechanicServices(
      name: json["name"],
      id: json["id"],
      price: json["price"],
      selected: json["selected"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name":name,
      "id":id,
      "price":price,
      "selected":selected,
    };
  }
}