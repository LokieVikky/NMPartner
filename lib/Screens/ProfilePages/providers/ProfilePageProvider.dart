import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProfilePageProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  Map employee = {};
  List services = [];
  var snapshot;
  var profileData;
  var selectedEmployee = 0;
  List shopTypeList = [];
  String loginID;

  Map selectedShopsBrands = {};
  String selectedShopType = '';
  Map removedShopsBrands = {};

  getProfile() async {
    var snap = await _firestore.collection('garages').doc(loginID).get();
    snapshot = snap;
    profileData = snap.data();
  }

  getEmployee() async {
    if (employee.isEmpty) {
      await _firestore
          .collection('garages')
          .doc(loginID)
          .collection('employee')
          .get()
          .then((value) => value.docs.forEach((element) {
                var data = element.data();
                data['id'] = element.id;
                employee[element.id] = data;
              }));
      notifyListeners();
    }
  }

  removeEmployee(id) {
    employee.remove(id);
    _firestore
        .collection('garages')
        .doc(loginID)
        .collection('employee')
        .doc(id)
        .delete();
    notifyListeners();
  }

  updateEmployee(
      {String name, File profile, String uid, String oldLink}) async {
    String profileImageLink;
    Map<String, String> data;
    var req = _firestore
        .collection('garages')
        .doc(loginID)
        .collection('employee')
        .doc(uid);
    if (profile != null) {
      var snapshot = await _storage
          .ref()
          .child('shop/$loginID/employee/$uid')
          .putFile(profile);

      profileImageLink = await snapshot.ref.getDownloadURL();
      data = {'name': name, 'profile': profileImageLink};
    } else {
      data = {'name': name, 'profile': oldLink};
    }

    req.update(data);
    employee.update(uid, (value) => data);
    notifyListeners();
  }

  addEmployee(String name, File profile) async {
    String profileImageLink;
    var req = _firestore
        .collection('garages')
        .doc(loginID)
        .collection('employee')
        .doc();
    var snapshot = await _storage
        .ref()
        .child('shop/$loginID/employee/${req.id}')
        .putFile(profile);

    profileImageLink = await snapshot.ref.getDownloadURL();

    var data = {'name': name, 'profile': profileImageLink};
    req.set(data);
    employee[req.id] = data;
    notifyListeners();
  }

  getServices() async {
    var snap = await _firestore.collection('garages').doc(loginID).get();
    var data = snap.get('services');
    services = data;
    notifyListeners();
  }

  addService(String name, var price) async {
    var data = {'name': name, 'price': price};
    await _firestore.collection('garages').doc(loginID).update({
      'services': FieldValue.arrayUnion([data])
    });
    services.add(data);
    notifyListeners();
  }

  updateService(String name, double price, int index) async {
    var data = {'name': name, 'price': price};
    services[index] = data;
    await _firestore
        .collection('garages')
        .doc(loginID)
        .update({'services': services});
    notifyListeners();
  }

  selectEmployee(int index, int selectedIndex) {
    selectedIndex = index;
    notifyListeners();
    return selectedIndex;
  }

  getShopType() {
    shopTypeList = profileData['shopType'];
    selectedShopsBrands = profileData['brands'];
  }

  addShopType(value) {
    selectedShopType = value;
    shopTypeList.add(value);
    notifyListeners();
  }

  removeShopType(value) {
    selectedShopType = '';
    shopTypeList.remove(value);
    notifyListeners();
  }

  updateProfile(Map<String, dynamic> data) async {
    if (shopTypeList.isEmpty) {
      data['shopType'] = [];
    } else {
      data['shopType'] = shopTypeList;
    }

    data['brands'] = selectedShopsBrands;
    print(selectedShopsBrands);
    await _firestore.collection('garages').doc(loginID).update(data);
    sampleTest();
    getProfile();
    notifyListeners();
  }

  login(id) {
    loginID = id;
  }

  brandTypeAdd(brandsName) {
    if (removedShopsBrands.containsKey(selectedShopType)) {
      List a = selectedShopsBrands[selectedShopType];
      if (a.contains(brandsName)) {
        a.remove(brandsName);
      }
    }

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
    if (removedShopsBrands.containsKey(selectedShopType)) {
      List a = removedShopsBrands[selectedShopType];
      a.add(brandsName);
    } else {
      removedShopsBrands[selectedShopType] = [];
      List a = removedShopsBrands[selectedShopType];
      a.add(brandsName);
    }
    List a = selectedShopsBrands[selectedShopType];
    a.remove(brandsName);
    notifyListeners();
  }

  sampleTest() {
    removedShopsBrands.forEach((key, value) {
      value.forEach((val) => _firestore
              .collection('vehicles')
              .doc(key.toString().toLowerCase())
              .update({
            val: FieldValue.arrayRemove([loginID])
          }));
    });

    shopTypeList.forEach((element) {
      if (!selectedShopsBrands.containsKey(element)) {
        selectedShopsBrands[element] = ['shops'];
      }
    });
    print(shopTypeList);
    print(selectedShopsBrands);
    selectedShopsBrands.forEach((key, value) {
      value.forEach((val) {
        print(val);
        return _firestore
            .collection('vehicles')
            .doc(key.toString().toLowerCase())
            .update({
          val: FieldValue.arrayUnion([loginID])
        });
      });
    });
  }
}
