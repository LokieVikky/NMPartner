import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/Screens/FormPage/register_personal_details.dart';
import 'package:partner/Screens/FormPage/register_shop_info.dart';
import 'package:partner/Screens/FormPage/widgets/register_shop_services.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class FormPage extends ConsumerStatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationStatusProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purewhite,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "REGISTER",
          style: MyTextStyle.text1,
        ),
      ),
      body: state.when(
        data: (data) {
          data = data ?? 0;
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Stepper(
                // onStepTapped: (int value) {
                //   setState(() {
                //     data = value;
                //   });
                // },
                currentStep: data == 3 ? 0 : data!,
                controlsBuilder: (context, c) {
                  return Container();
                },
                type: StepperType.horizontal,
                steps: [
                  Step(
                    isActive: data == 0,
                    title: Text('Personal'),
                    content: RegisterPersonalDetails(),
                  ),
                  Step(
                    isActive: data == 1,
                    title: Text('Shop'),
                    content: RegisterShopInfo(),
                  ),
                  Step(
                    isActive: data == 2,
                    title: Text('Services'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height - kToolbarHeight - 170,
                      child: RegisterShopServices(),
                    ),
                  )
                ],
              );
            },
          );
        },
        error: (error, stackTrace) {
          print(stackTrace);
          return Center(
            child: Text('Error Occurred'),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.yellow, strokeWidth: 6),
          );
        },
      ),
    );
  }
}

showSnack(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
      fontSize: 15.0,
    );
