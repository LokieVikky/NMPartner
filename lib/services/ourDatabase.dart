import 'package:cloud_firestore/cloud_firestore.dart';

class OurDatabase {
  FirebaseFirestore _instance = FirebaseFirestore.instance;

  //this will just be used to initail signup of the user
  Future<String> createUser({String phone, String uid}) {

    try {
      String retVal;
      retVal = "error";
      _instance.collection("garages").doc(uid).set(
          {"phone": phone, "uid": uid, "type": "garage", "register": false});

      retVal = "success";
    } catch (e) {
      print(e);
    }
  }
}
