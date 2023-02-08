import 'package:partner/shared/helper.dart';

class ShopEntity {
  String? shopName;
  String? shopDescription;
  String? shopNo;
  String? street;
  String? city;
  String? pincode;
  String? landmark;
  String? latlng;
  String? avatarUrl;
  String? partnerId;
  String? shopId;

  ShopEntity(
      {this.shopName,
      this.shopDescription,
      this.shopNo,
      this.street,
      this.city,
      this.pincode,
      this.landmark,
      this.latlng,
      this.partnerId,
      this.shopId,
      this.avatarUrl});

  ShopEntity.fromJson(Map json) {
    shopName = json['name'];
    shopDescription = json['description'];
    shopNo = helper.getFirstIndexValue(json['addresses'], key: 'house_no');
    street = helper.getFirstIndexValue(json['addresses'], key: 'apartment_road_area');
    city = helper.getFirstIndexValue(json['addresses'], key: 'city');
    pincode = helper.getFirstIndexValue(json['addresses'], key: 'pincode');
    landmark = helper.getFirstIndexValue(json['landmark'], key: 'pincode');
    latlng = json[''];
    partnerId = json[''];
    shopId = json[''];
    avatarUrl = json[''];
  }
}
