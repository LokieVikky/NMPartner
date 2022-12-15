class FormData {
  final String? formID;
  final String? fullName;
  final String? shopName;
  final String? description;
  final Map? address;
  final Map? shopImages;
  final Map? verificationDocuments;
  final List? empDetails;
  final List? services;
  final List? shopType;
  final Map? brands;
  final List? currentOrder;
  final List? orderHistory;

  FormData({
    this.brands,
    this.currentOrder,
    this.orderHistory,
    this.verificationDocuments,
    this.services,
    this.shopType,
    this.formID,
    this.fullName,
    this.shopName,
    this.description,
    this.address,
    this.shopImages,
    this.empDetails,
  });

  factory FormData.fromJSON(Map<String, dynamic> json) {
    return FormData(
        formID: json['formID'],
        orderHistory: [],
        currentOrder: [],
        fullName: json['fullName'],
        shopName: json['shopName'],
        description: json['description'],
        address: json['address'],
        shopImages: json['shopImages'],
        empDetails: json['empDetails'],
        services: json['services'],
        shopType: json['shopType'],
        brands: json['shopType'],
        verificationDocuments: json['verificationDocuments']);
  }

  Map<String, dynamic> toMap() {
    return {
      'orderHistory': [],
      'currentOrder': [],
      'brands': {},
      'formID': formID,
      'fullName': fullName,
      'shopName': shopName,
      'description': description,
      'address': address,
      'shopImages': shopImages,
      'empDetails': empDetails,
      'services': services,
      'shopType': shopType,
      'verificationDocuments': verificationDocuments
    };
  }
}
