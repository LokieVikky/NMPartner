
import 'package:hive/hive.dart';
import 'package:partner/models/garage/sub_models/MechanicServies.dart';
import 'package:partner/models/garage/sub_models/ownerDetailsModel.dart';

part 'garageModel.g.dart';

@HiveType(typeId: 112, adapterName: 'garageModelHiveGen')
class OurGarage {

  @HiveField(0)
  String uid; // this will be the unique uid of the garage that will be used to first find the garage and then place the order to that mechanic

  @HiveField(1)
  String name; // name of the garage

  @HiveField(2)
  String type; // type of the business

  @HiveField(3)
  String establishedYear;

  @HiveField(4)
  String aboutUs;

  @HiveField(5)
  bool status; // is the garage taking orders at the moment or not

  @HiveField(6)
  Map openTime; // this will contain the opening time of the garage

  @HiveField(7)
  Map closeTime; // this will contain the closing time of the garage

  @HiveField(8)
  Map images; // this will contain two lists profileImages, carosuelImgs

  @HiveField(9)
  Map contacts;

  @HiveField(10)
  Map address; // lat, long, shopno, street, city, state, pincode

  @HiveField(11)
  OwnerDetailsModel ownerDetails;
  //List<MechanicServices> servicesOffered;  // this needs to contain the services that the particular garage offers to the user

  @HiveField(12)
  var vehiclesServices; // the types of vehicles that the garage can service

  @HiveField(13)
  double satisfaction;

  @HiveField(14)
  String distanceAway;

  @HiveField(15)
  List<MechanicServices> products;
  //List

  OurGarage({
    this.uid,
    this.name,
    this.type,
    this.establishedYear,
    this.aboutUs,
    this.status,
    this.openTime,
    this.closeTime,
    this.images,
    this.contacts,
    this.address,
    this.ownerDetails,
    this.vehiclesServices,
    this.satisfaction,
    this.distanceAway,
    this.products,
    //this.servicesOffered
  });


  factory OurGarage.fromJSON(Map<String, dynamic> json) {

    List<MechanicServices> productsListUpdated = [];

    json["products"].forEach((element) {
      productsListUpdated.add(
        MechanicServices.fromJSON(element)
      );
    });


    return OurGarage(
      aboutUs: json["aboutUs"],
      status: json["status"],
      type: json["type"],
      uid: json["uid"],
      distanceAway: json["distanceAway"],
      name: json["name"],
      establishedYear: json["establishedYear"],
      address: json["address"],
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      contacts: json["contacts"],
      images: json["images"],
      ownerDetails: OwnerDetailsModel.fromJSON(json["ownerDetails"]),
      products:productsListUpdated,
      satisfaction: json["satisfaction"],
      vehiclesServices: json["vehiclesServices"],
    );
  }

  Map<String, dynamic> toMap() {


    List<Map<String,dynamic>> productsList = [];
    products.forEach((element) {
      productsList.add(
        element.toMap()
      );
    });


    return {
      'aboutUs':aboutUs,
      "status":status,
      "type":type,
      "uid":uid,
      "distanceAway":distanceAway,
      "name":name,
      "establishedYear":establishedYear,
      "address":address,
      "openTime":openTime,
      "closeTime":closeTime,
      "contacts":contacts,
      "images":images,
      "ownerDetails":ownerDetails.toMap(),
      "products":productsList,
      "vehicleServices":vehiclesServices,
      "satisfaction":satisfaction,
    };

  }

}
