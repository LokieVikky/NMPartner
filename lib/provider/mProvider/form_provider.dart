import 'package:partner/models/formData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
/*
  String? formID;
  var uuid;
  String? fullName;
  String? shopName;
  String? description;
  String? shopNo;
  String? street;
  String? city;
  String? state;
  String? pincode;

  Map? address;
  Map? shopImages;
  List? shopTypeList = [];
  List? carouselImages;
  List? services;

  Map selectedShopsBrands = {};
  String selectedShopType = '';

  // String _form;

  //Getters
  String? get form => fullName;

  saveData(
      {aadharCard,
      panCard,
      aadharLink,
      panLink,
      services,
      fullName,
      shopName,
      description,
      profileImageURL,
      carouselImages,
      shopNo,
      street,
      city,
      state,
      empDetails,
      pincode,
      formID}) {
    Map local = {
      "shopNo": shopNo,
      "street": street,
      "city": city,
      "state": state,
      "pincode": pincode,
    };

    Map images = {
      "profile": profileImageURL,
      "carouselImages": carouselImages,
    };

    Map verificationDocuments = {
      'aadharCard': aadharCard,
      'panCard': panCard,
      'aadharCardLink': aadharLink,
      'pancardLink': panLink
    };
    if (formID == null) {
      var newData = FormData(
          formID: formID,
          fullName: fullName,
          shopName: shopName,
          description: description,
          address: local,
          shopImages: images,
          verificationDocuments: verificationDocuments,
          shopType: shopTypeList,
          brands: selectedShopsBrands,
          services: services,
          orderHistory: [],
          currentOrder: [],
          empDetails: empDetails);

    } else {
      var updatedEntry = FormData(
          formID: formID,
          orderHistory: [],
          currentOrder: [],
          brands: selectedShopsBrands,
          fullName: fullName,
          shopName: shopName,
          description: description,
          address: local,
          shopImages: images,
          verificationDocuments: verificationDocuments,
          shopType: shopTypeList,
          services: services,
          empDetails: empDetails);
      sampleTest(formID);
    }
  }

  shopTypeAdd(type) {
    selectedShopType = type;
    shopTypeList!.add(type);
    notifyListeners();
  }

  shopTypeRemove(type) {
    selectedShopType = '';
    shopTypeList!.remove(type);
    notifyListeners();
  }

  brandTypeAdd(brandsName) {
    if (selectedShopsBrands.containsKey(selectedShopType)) {
      List a = selectedShopsBrands[selectedShopType];
      a.add(brandsName);
    } else {
      selectedShopsBrands[selectedShopType] = [];
      List a = selectedShopsBrands[selectedShopType];
      a.add(brandsName);
    }
    notifyListeners();
  }

  brandTypeRemove(brandsName) {
    List a = selectedShopsBrands[selectedShopType];
    a.remove(brandsName);
    notifyListeners();
  }

  sampleTest(uuid) {
    shopTypeList!.forEach((element) {
      if (!selectedShopsBrands.containsKey(element)) {
        selectedShopsBrands[element] = ['shops'];
      }
    });
  }*/
}
