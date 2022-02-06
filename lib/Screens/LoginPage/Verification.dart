import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/provider/currentState.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  final String phone, aadhaarNo;

  Verification(this.phone, this.aadhaarNo);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String _verificationCode;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    _instance.verifyPhone(widget.phone, context);
  }

  void dispose() {
    super.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                top: 100.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    // alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Verification code ",
                            style: MyTextStyle.heading4,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 5.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: MyColors.lightgrey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the verification code sent \non your associated phone number ${widget.phone}.",
                      style: MyTextStyle.text10,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 50.0,
                            bottom: 5.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "CODE",
                            style: MyTextStyle.text10,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: PinEntryTextField(
                              fields: 6,
                              showFieldAsBox: true,
                              isTextObscure: false,
                              onSubmit: (v) {
                                _codeController.text = v;
                                return _instance.verifyOtp(v, context);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          _verifyPhone().then(() => Fluttertoast.showToast(
                                  msg:
                                      "The Otp has been sent to your mobile again",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: MyColors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 20.0)
                              .toString());
                        },
                        child: Text(
                          "Resend code?",
                          style: MyTextStyle.text9,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _instance
                              .verifyOtp(_codeController.value.text, context);
                        },
                        child: Container(
                          height: _height / 15,
                          width: _width / 3,
                          margin: EdgeInsets.only(top: 20.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: MyColors.shopButton,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Verify",
                                  style: MyTextStyle.shopButton2,
                                ),
                                Icon(
                                  Icons.arrow_forward_sharp,
                                  color: MyColors.yellowish,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print('User loggedin');
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }
}
