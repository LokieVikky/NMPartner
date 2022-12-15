import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/Screens/FormPage/partnerInfo.dart';
import 'package:partner/Screens/FormPage/shopInfo.dart';
import 'package:partner/Screens/FormPage/shopType.dart';
import 'package:partner/provider/mProvider/currentStepProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class FormPage extends ConsumerStatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  @override
  void initState() {
    ref.read(currentStepNotifierProvider.notifier).getCurrentStep();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CurrentFormState state = ref.watch(currentStepNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.purewhite,
          elevation: 1,
          centerTitle: true,
          title: Text(
            "REGISTER",
            style: MyTextStyle.text1,
          ),
        ),
        body: () {
          switch (state.status!) {
            case CurrentFormStateStatus.initial:
            case CurrentFormStateStatus.loading:
              return Center(
                child: CircularProgressIndicator(
                    color: MyColors.yellow, strokeWidth: 6),
              );
            case CurrentFormStateStatus.success:
              int data = state.cState!;
              // /*if (data == 3) {
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //       '/homePage', (Route<dynamic> route) => false);
              // }*/
              return Stepper(
                  currentStep: data == 3 ? 0 : data,
                  controlsBuilder: (context, c) {
                    return SizedBox();
                  },
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                        isActive: data == 0,
                        title: Text('Personal'),
                        content: PartnerInfo()),
                    Step(
                        isActive: data == 1,
                        title: Text('Shop'),
                        content: ShopInfo()),
                    Step(
                        isActive: data == 2,
                        title: Text('Services'),
                        content: ShopType())
                  ]);
            case CurrentFormStateStatus.failure:
              return Center(
                child: Text('Error Occurred'),
              );
          }
        }());
  }
}

showSnack(String msg) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.yellow,
    textColor: Colors.black,
    fontSize: 15.0);
