import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/entity/verificationEntity.dart';
import 'package:partner/provider/mProvider/otpProvider.dart';
import 'package:partner/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state/otpState.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class Verification extends ConsumerStatefulWidget {
  final String phone, aadhaarNo;

  Verification(this.phone, this.aadhaarNo);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  String _verificationCode = '';
  final TextEditingController _codeController = TextEditingController();

  void dispose() {
    super.dispose();
    _codeController.dispose();
    // ref.refresh(otpNotifierProvider);
  }

  @override
  void initState() {
    () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('prefPhone', widget.phone);
    }();
    ref.read(otpNotifierProvider.notifier).getOtp(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    OtpState state = ref.watch(otpNotifierProvider);
    print('Verification ->' + state.verificationEntity.toString());
    return Scaffold(
      body: SafeArea(child: () {
        return state.verificationEntity.when(data: (data) {
          _verificationCode = data.otp!;
          savePref(data);
          ApiService()
              .saveToken(token: data.apiToken!, partnerID: data.partnerId!);
          return getUi(context, width, height);
        }, error: (code, errTxt) {
          return getErrorWidget(code, errTxt!);
        }, loading: () {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: AppColors.yellow, strokeWidth: 6),
                ],
              ),
            ],
          );
        });
      }()),
    );
  }

  Widget getUi(BuildContext context, double width, double height) {
    return SingleChildScrollView(
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
                        color: AppColors.lightgrey3,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.15,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                  child: Text(_verificationCode.isEmpty
                                      ? ''
                                      : _verificationCode[0]))),
                          Container(
                              width: width * 0.15,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                  child: Text(_verificationCode.isEmpty
                                      ? ''
                                      : _verificationCode[1]))),
                          Container(
                              width: width * 0.15,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                  child: Text(_verificationCode.isEmpty
                                      ? ''
                                      : _verificationCode[2]))),
                          Container(
                              width: width * 0.15,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                  child: Text(_verificationCode.isEmpty
                                      ? ''
                                      : _verificationCode[3])))
                        ],
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(otpNotifierProvider.notifier).getOtp(widget.phone);
                  },
                  child: Text(
                    "Resend code?",
                    style: MyTextStyle.text9,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_verificationCode.isNotEmpty) {
                      Navigator.pushNamed(context, "/form");
                    }
                  },
                  child: Container(
                    height: height / 15,
                    width: width / 3,
                    margin: EdgeInsets.only(top: 20.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      color: AppColors.shopButton,
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
                            color: AppColors.yellowish,
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
    );
  }

  Widget getErrorWidget(Object code, StackTrace errTxt) {
    print('error widget');
    return Text(
      'Error Code : $code \nError Msg: $errTxt',
      textAlign: TextAlign.left,
      style: MyTextStyle.formHeading,
    );
  }

  void savePref(VerificationEntity data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('prefPhone', data.phoneNumber!);
  }
}
