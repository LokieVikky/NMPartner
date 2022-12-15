class OrderModel{
  String? userUID;
  String? garageUID;
  String? userPhone;
  String? name;
  Map? address;
  String? orderId;
  String? otp;
  bool? pickup;
  Map? charges;
  List? services;
  String? shopName;
  String? vehicleName;
  String? vehicleBrand;
  String? vehicleType;


  OrderModel({
    this.name,
    this.orderId,
    this.vehicleType,
    this.address,
    this.shopName,
    this.services,
    this.userPhone,
    this.charges,
    this.garageUID,
    this.otp,
    this.pickup,
    this.userUID,
    this.vehicleBrand,
    this.vehicleName,
  });
}