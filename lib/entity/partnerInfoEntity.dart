class PartnerInfoEntity {
  String? partnerName;
  String? partnerPhone;
  String? partnerFlatNo;
  String? partnerAddressId;
  String? partnerStreet;
  String? partnerCity;
  String? partnerLandmark;
  String? partnerLatlng;
  String? partnerPincode;
  String? partnerAadhaarFront;
  String? partnerAadhaarBack;
  String? partnerAadhaarNo;
  String? partnerPanFront;
  String? partnerPanBack;
  String? partnerPanNo;
  String? partnerProfilePic;
  String? partnerID;

  PartnerInfoEntity({
    this.partnerName,
    this.partnerPhone,
    this.partnerAddressId,
    this.partnerFlatNo,
    this.partnerStreet,
    this.partnerCity,
    this.partnerLandmark,
    this.partnerLatlng,
    this.partnerPincode,
    this.partnerAadhaarFront,
    this.partnerAadhaarBack,
    this.partnerAadhaarNo,
    this.partnerPanFront,
    this.partnerPanBack,
    this.partnerProfilePic,
    this.partnerID,
    this.partnerPanNo,
  });

  PartnerInfoEntity.fromJson(dynamic json) {
    partnerName = json['name'];
    partnerPhone = json['phone'];
    partnerFlatNo = json['addresses']?[0]?['house_no'];
    partnerAddressId = json['addresses']?[0]?['id'];
    partnerStreet = json['addresses']?[0]?['apartment_road_area'];
    partnerCity = json['addresses']?[0]?['city'];
    partnerLandmark = json['addresses']?[0]?['landmark'];
    partnerPincode = json['addresses']?[0]?['pincode'];
    Map<String, dynamic> aadhar = json['documents'] != null
        ? (json['documents'] as List)
            .singleWhere((element) => element['document_type'] == 'AADHAR', orElse: () => {})
        : {};
    Map<String, dynamic> pan = json['documents'] != null
        ? (json['documents'] as List)
        .singleWhere((element) => element['document_type'] == 'PAN', orElse: () => {})
        : {};

    partnerAadhaarFront = aadhar['photo_front'];
    partnerAadhaarBack = aadhar['photo_back'];
    partnerAadhaarNo = aadhar['document_number'];
    partnerPanFront = pan['photo_front'];
    partnerPanBack = pan['photo_back'];
    partnerPanNo = pan['document_number'];
    partnerProfilePic = json['avatar'];
    partnerID = json['id'];
  }
}
