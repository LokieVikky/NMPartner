import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class orderProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String loginUID;
  List showed = [];
  List data = [];
  List ids = [];

  List showedHistory = [];
  List dataHistory = [];
  List idsHistory = [];

  login(id) {
    loginUID = id;
  }

  Stream getOrder() async* {
    var ac = _firestore.collection('garages').doc(loginUID).snapshots();
    ac.listen((event) {
      ids = event.data()['currentOrder'];
      getOrders(ids);
    });
    yield ids;
  }

  getOrders(List ids) async {
    DocumentSnapshot snap;
    for (var element in ids) {
      if (!showed.contains(element)) {
        showed.add(element);
        snap = await _firestore.collection('currentOrder').doc(element).get();
        data.add(snap.data());
      }
    }
    notifyListeners();
  }

  Stream orderHistory() async* {
    var ac = _firestore.collection('garages').doc(loginUID).snapshots();
    ac.listen((event) {
      idsHistory = event.data()['orderHistory'];
      getOrdersHistory(idsHistory);
    });
    yield ids;
  }

  getOrdersHistory(List ids) async {
    DocumentSnapshot snap;
    for (var element in ids) {
      if (!showedHistory.contains(element)) {
        showedHistory.add(element);
        snap = await _firestore.collection('orderHistory').doc(element).get();
        dataHistory.add(snap.data());
      }
    }
    notifyListeners();
  }

  updateOrder(var id, int stage, empName, empId, profile) async {
    if (stage == 2) {
      await _firestore.collection('currentOrder').doc(id).update({
        'stage': stage,
        'empName': empName,
        'empUID': empId,
        'empUrl': profile
      });
    } else if (stage == 4) {}
    notifyListeners();
  }

  orderCompleted(var orderdata) async {
    await _firestore.collection('garages').doc(loginUID).update({
      'currentOrder': FieldValue.arrayRemove([orderdata['id']]),
      'orderHistory': FieldValue.arrayUnion([orderdata['id']]),
    });
    await _firestore.collection('users').doc(orderdata['userUID']).update({
      'orders': FieldValue.arrayRemove([orderdata['id']]),
      'orderHistory': FieldValue.arrayUnion([orderdata['id']]),
    });
    await _firestore
        .collection('orderHistory')
        .doc(orderdata['id'])
        .set(orderdata);
    await _firestore.collection('currentOrder').doc(orderdata['id']).delete();
    data.remove(orderdata);
    // showed.remove(orderdata);
    notifyListeners();
  }

  cancelOrder(var orderdata) async {
    await _firestore.collection('garages').doc(loginUID).update({
      'currentOrder': FieldValue.arrayRemove([orderdata['id']]),
      'orderHistory': FieldValue.arrayUnion([orderdata['id']]),
    });
    await _firestore.collection('users').doc(orderdata['userUID']).update({
      'orders': FieldValue.arrayRemove([orderdata['id']]),
      'orderHistory': FieldValue.arrayUnion([orderdata['id']]),
    });
    data.remove(orderdata);
    notifyListeners();
  }
}
