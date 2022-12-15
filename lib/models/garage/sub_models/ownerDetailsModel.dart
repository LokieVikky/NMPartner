
import 'package:hive/hive.dart';


@HiveType(typeId: 111, adapterName: 'OwnerDetailsModelHiveGen')
class OwnerDetailsModel {

  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String? gender;

  @HiveField(4)
  final int? age;

  OwnerDetailsModel(
      {this.title, this.firstName, this.lastName, this.gender, this.age});


  factory OwnerDetailsModel.fromJSON(Map<String, dynamic> json2) {
      return OwnerDetailsModel(
        lastName: json2["lastName"],
        firstName: json2["firstName"],
        age: json2["age"],
        gender: json2["gender"],
        title: json2["title"],
      );
  }

  Map<String, dynamic> toMap() {
    return {
      "age":age,
      "firstName":firstName,
      "gender":gender,
      "lastName":lastName,
      "title":title,
    };
  }
}