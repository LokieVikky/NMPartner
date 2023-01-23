import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/models/garage/garageModel.dart';
import 'package:partner/services/ourDatabase.dart';
import 'package:partner/values/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentState extends ChangeNotifier {
/*
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  SharedPreferences? prefs;
  UserCredential? authResult;
  OurGarage? currentUser;

  preference() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? _verificationCode;
  String? phoneNo, smsSent, _verificationId;
  String? _inputText;

  Future<void> verifyPhone(String inputText, context) async {
    _inputText = inputText;
    final PhoneVerificationCompleted verifiedSuccess =
        (PhoneAuthCredential phoneAuthCredential) {
      Fluttertoast.showToast(
              msg: "Verification is successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColors.yellow,
              textColor: Colors.black,
              fontSize: 20.0)
          .toString();
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(authException);
    };

    PhoneCodeSent codeSent =
        (String? verificationId, [int? forceCodeResent]) async {
      Fluttertoast.showToast(
              msg: "The Otp has been sent to your mobile",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColors.yellow,
              textColor: Colors.black,
              fontSize: 20.0)
          .toString();
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$inputText',
        timeout: const Duration(seconds: 120),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      // Fluttertoast.showToast(
      //         msg: "Sorry Some error has occur Please Contact Developer \n $e",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: MyColors.yellow,
      //         textColor: Colors.black,
      //         fontSize: 20.0)
      //     .toString();
      print(e);
    }
    notifyListeners();
  }

  formVerified() async {
    prefs!.setString('form', 'true');
    await _firestore
        .collection("garages")
        .doc(prefs!.getString('loginID'))
        .set({"register": true});
  }

  verifyOtp(String input, context) async {
    String? retVal = "error";
    OurGarage _user = OurGarage();
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: input);
    try {
      authResult = await _auth.signInWithCredential(credential);

      // Here i have to save the details of the user in the database
      if (authResult!.additionalUserInfo!.isNewUser) {
        prefs!.setString('loginID', authResult!.user!.uid);
        prefs!.setString('form', 'false');
        retVal = await OurDatabase()
            .createUser(phone: '+91$_inputText', uid: authResult!.user!.uid);
        print(
            '*************************************${prefs!.getString('form')}');

        await Navigator.pushNamedAndRemoveUntil(
            context, "/formPage", (route) => false);
      } else {
        if (prefs!.getString('form') == null) {
          bool register = false;
          await _firestore
              .collection('garages')
              .doc(authResult!.user!.uid)
              .get()
              .then((value) => register = value.get('register'));
          if (register) {
            prefs!.setString('form', 'true');
            prefs!.setString('loginID', authResult!.user!.uid);
            await Navigator.pushNamedAndRemoveUntil(
                context, "/homePage", (route) => false);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
                context, "/formPage", (route) => false);
          }
        }
        prefs!.setString('loginID', authResult!.user!.uid);

        await Navigator.pushNamedAndRemoveUntil(
            context, "/homePage", (route) => false);
        if (authResult != null) {}
      }
      print("End of the await");

      // when signup with the otp
      if (retVal == "success") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/homePage", (route) => false);
      }
    } catch (e) {
      print(e);
      // Fluttertoast.showToast(
      //         msg: "Sorry Some error has occur Please Contact Developer \n $e",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: MyColors.yellow,
      //         textColor: Colors.black,
      //         fontSize: 20.0)
      //     .toString();
    }
  }
*/
}
