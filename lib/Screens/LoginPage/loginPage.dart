import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:partner/screens/LoginPage/Verification.dart';
import 'package:partner/services/apiService.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  bool phoneValid = false;
  bool aadharValid = false;
  String? imageURL;
  bool ConnectionCheck = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    () async {
      String? accessToken = await ApiService().readAccessToken();
      if(accessToken != null && accessToken.isNotEmpty) {
        Navigator.pushNamed(context, '/form');
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _picker = ImagePicker();
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 100.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 20.0,
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
                                padding: EdgeInsets.only(
                                  left: 30.0,
                                  right: 30.0,
                                ),
                                child: Image.asset('assets/images/logo.png'),
                                height: _height / 12,
                                width: _width / 1.5,
                                margin: EdgeInsets.only(
                                  bottom: 20.0,
                                ),
                                alignment: Alignment.center,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 30.0,
                                  right: 30.0,
                                ),
                                height: _height / 5,
                                width: _width,
                                margin: EdgeInsets.only(
                                  bottom: 20.0,
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/text.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1.0),
                            ),
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your phone no.',
                              icon: Image.asset('assets/images/phone.png'),
                              prefix: Text("+91"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if ((_phoneController.text.length != 10)) {
                              Fluttertoast.showToast(
                                  msg: 'Invalid phone number',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 20.0);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Verification(
                                      _phoneController.text,
                                      _aadhaarController.text)));
                            }
                          },
                          child: Container(
                            height: _height / 15,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              color: MyColors.shopButton,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 150.0),
                                  child: Text(
                                    "Continue",
                                    style: MyTextStyle.text15,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.arrow_forward_sharp,
                                    color: MyColors.yellowish,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // todo CodeChanged
                Visibility(
                  visible: ConnectionCheck,
                  child: Container(
                      width: size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lotties/connection.json',
                              width: size.width * 0.8),
                          Text('Waiting for Connection...')
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
