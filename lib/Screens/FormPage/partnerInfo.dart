import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:partner/provider/mProvider/currentStepProvider.dart';
import 'package:partner/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../aws/aws_storage.dart';
import '../../entity/partnerInfoEntity.dart';
import '../../provider/mProvider/imageProvider.dart';
import '../../provider/mProvider/partnerInfoProvider.dart';
import '../../state/partnerState.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class PartnerInfo extends ConsumerStatefulWidget {
  const PartnerInfo({Key? key}) : super(key: key);

  @override
  _PartnerInfoState createState() => _PartnerInfoState();
}

class _PartnerInfoState extends ConsumerState<PartnerInfo> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  final TextEditingController _shopNo = TextEditingController();
  final TextEditingController _priceRate = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _landMark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _otherName = TextEditingController();
  final TextEditingController _aadhaar = TextEditingController();
  final TextEditingController _panCard = TextEditingController();
  final _picker = ImagePicker();
  List<Asset> images = <Asset>[];
  List carouselImages = [];
  File? profileImageUrl;
  String? profileImageLink;
  List services = [];
  var _error = 'no error was detected';
  bool loading = false;

  // newDev
  File? profilePic;
  String? profilePicUrl;

  File? panPic;
  String? panPicUrl;

  File? aadhaarPic;
  String? aadhaarPicUrl;
  String? phoneNumber = "";

  @override
  void dispose() {
    // TODO: implement dispose
    _fullName.dispose();
    _contactNumber.dispose();
    _shopNo.dispose();
    _priceRate.dispose();
    _street.dispose();
    _city.dispose();
    _pincode.dispose();
    _otherName.dispose();
    services.clear();
    _aadhaar.dispose();
    _panCard.dispose();
    images.clear();
    super.dispose();
  }

  Widget setImage(File? file) {
    return Container(
      width: 115,
      height: 115,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: file != null
            ? Image.file(file, fit: BoxFit.cover)
            : Image.asset('assets/images/car.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      phoneNumber = await pref.getString('prefPhone');
      _contactNumber.text = phoneNumber!;
    }();

    return () {
      return StatefulBuilder(builder: (context, setState) {
        PartnerState state = ref.watch(partnerNotifierProvider);
        switch (state.status) {
          case UpdatePartnerStatus.initial:
          case UpdatePartnerStatus.success:
          case UpdatePartnerStatus.failure:
            loading = false;
            break;
          case UpdatePartnerStatus.loading:
            loading = true;
            break;
        }

        return Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (validateForm()) {
                        ref
                            .read(partnerNotifierProvider.notifier)
                            .setLoadingState();

                        String profilePicURL =
                            await uploadFile(ref.watch(profilePicProvider)!);
                        String aadhaarFrontPicURL = await uploadFile(
                            ref.watch(aadhaarFrontPicProvider)!);
                        String aadhaarBackPicURL = await uploadFile(
                            ref.watch(aadhaarBackPicProvider)!);
                        String panFrontPicURL =
                            await uploadFile(ref.watch(panFrontPicProvider)!);
                        String panBackPicURL =
                            await uploadFile(ref.watch(panBackPicProvider)!);

                        PartnerInfoEntity mModel = await PartnerInfoEntity(
                            partnerName: _fullName.text,
                            partnerFlatNo: _shopNo.text,
                            partnerStreet: _street.text,
                            partnerCity: _city.text,
                            partnerLatlng: "1.1",
                            // todo: should do
                            partnerLandmark: _landMark.text,
                            partnerPincode: _pincode.text,
                            partnerAadhaarFront: aadhaarFrontPicURL,
                            partnerAadhaarBack: aadhaarBackPicURL,
                            partnerAadhaarNo: _aadhaar.text,
                            partnerPanFront: panFrontPicURL,
                            partnerPanBack: panBackPicURL,
                            partnerPanNo: _panCard.text,
                            partnerID: await ApiService().readPartnerId(),
                            partnerProfilePic: profilePicURL);

                        await ref
                            .read(partnerNotifierProvider.notifier)
                            .updatePartnerInfo(mModel);
                      }
                    },
                    child: Container(
                      height: _height / 15,
                      width: _width,
                      margin: EdgeInsets.only(
                        top: 20.0,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: MyColors.yellow,
                      ),
                      child: Text(
                        "SAVE",
                        style: MyTextStyle.button1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Color(0x80ffeb0f),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        );
      });
    }();
  }

  Widget _buildForm(double _width, double _height) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Center(
              child: Text(
                "Partner profile",
                style: MyTextStyle.formHeading,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  // profileImage();
                  pickSinglePic(profilePicProvider);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 115,
                      width: 115,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: MyColors.purple),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Column(
                      children: [
                        Consumer(builder: (context, ref, child) {
                          File? file = ref.watch(profilePicProvider);
                          return setImage(file);
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Center(
              child: Text(
                "Upload your image",
                style: MyTextStyle.formSubHeading,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Full name",
                    style: MyTextStyle.formLabel,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _fullName,
                    maxLength: 70,
                    keyboardType: TextInputType.name,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: MyTextStyle.formTextField,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Contact Number",
                    style: MyTextStyle.formLabel,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _contactNumber,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: MyTextStyle.formTextField,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Address",
                    style: MyTextStyle.formLabel,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "House no./ Flat no.",
                          style: MyTextStyle.formLabel,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _shopNo,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: MyTextStyle.formTextField,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Street/town",
                          style: MyTextStyle.formLabel,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _street,
                          maxLength: 50,
                          keyboardType: TextInputType.name,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: MyTextStyle.formTextField,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "City",
                              style: MyTextStyle.formLabel,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: _width * 0.4,
                            child: TextFormField(
                              controller: _city,
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColors.yellow,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColors.yellow,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              style: MyTextStyle.formTextField,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Pincode",
                              style: MyTextStyle.formLabel,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: _width * 0.4,
                            child: TextFormField(
                              controller: _pincode,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColors.yellow,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: MyColors.yellow,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              style: MyTextStyle.formTextField,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Landmark",
                          style: MyTextStyle.formLabel,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _landMark,
                          keyboardType: TextInputType.name,
                          maxLength: 25,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors.yellow,
                                width: 2.0,
                              ),
                            ),
                          ),
                          style: MyTextStyle.formTextField,
                        ),
                      ),
                    ],
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
              "Verification Documents",
              style: MyTextStyle.formLabel,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Aadhar EPIC number",
                    style: MyTextStyle.formLabel,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _aadhaar,
                    maxLength: 12,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: MyTextStyle.formTextField,
                  ),
                ),
              ],
            ),
          ),
          DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                child: Consumer(builder: (context, ref, child) {
                  File? aadhaarFrontPic = ref.watch(aadhaarFrontPicProvider);
                  return aadhaarFrontPic == null
                      ? Container(
                          margin: EdgeInsets.all(
                            20.0,
                          ),
                          width: _width,
                          child: Column(
                            children: [
                              Text(
                                "Upload your Aadhaar front photo",
                                style: MyTextStyle.text4,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(
                                Icons.image_outlined,
                                color: MyColors.pureblack,
                                size: 30.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_aadhaar.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else if (_aadhaar.text.length != 12) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else {
                                        pickFromCamera(aadhaarFrontPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, right: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        border: Border.all(
                                            color: MyColors.pureblack),
                                      ),
                                      child: Text(
                                        "Camera",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_aadhaar.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else if (_aadhaar.text.length != 12) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else {
                                        pickFromGallery(
                                            aadhaarFrontPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, left: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        color: MyColors.yellow,
                                      ),
                                      child: Text(
                                        "Browse",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => ref.refresh(aadhaarFrontPicProvider),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                    color: Colors.deepPurple,
                                    child: Image.file(aadhaarFrontPic,
                                        fit: BoxFit.cover)),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.cancel_rounded,
                                      color: MyColors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                }),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                child: Consumer(builder: (context, ref, child) {
                  File? aadhaarBackPic = ref.watch(aadhaarBackPicProvider);
                  return aadhaarBackPic == null
                      ? Container(
                          margin: EdgeInsets.all(
                            20.0,
                          ),
                          width: _width,
                          child: Column(
                            children: [
                              Text(
                                "Upload your Aadhaar back photo",
                                style: MyTextStyle.text4,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(
                                Icons.image_outlined,
                                color: MyColors.pureblack,
                                size: 30.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_aadhaar.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else if (_aadhaar.text.length != 12) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else {
                                        pickFromCamera(aadhaarBackPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, right: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        border: Border.all(
                                            color: MyColors.pureblack),
                                      ),
                                      child: Text(
                                        "Camera",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_aadhaar.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else if (_aadhaar.text.length != 12) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Aadhaar number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else {
                                        pickFromGallery(aadhaarBackPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, left: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        color: MyColors.yellow,
                                      ),
                                      child: Text(
                                        "Browse",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => ref.refresh(aadhaarBackPicProvider),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                    color: Colors.deepPurple,
                                    child: Image.file(aadhaarBackPic,
                                        fit: BoxFit.cover)),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.cancel_rounded,
                                      color: MyColors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                }),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your PAN number",
                    style: MyTextStyle.formLabel,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _panCard,
                    maxLength: 10,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColors.yellow,
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: MyTextStyle.formTextField,
                  ),
                ),
              ],
            ),
          ),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              child: Consumer(builder: (context, ref, child) {
                File? panFrontPic = ref.watch(panFrontPicProvider);
                return panFrontPic == null
                    ? Container(
                        margin: EdgeInsets.all(
                          20.0,
                        ),
                        width: _width,
                        child: Column(
                          children: [
                            Text(
                              "Upload your PAN card front photo",
                              style: MyTextStyle.text4,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Icon(
                              Icons.image_outlined,
                              color: MyColors.pureblack,
                              size: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_panCard.text.isEmpty) {
                                      Fluttertoast.showToast(
                                              msg:
                                                  "Please enter your Pan Card number before selecting image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: MyColors.yellow,
                                              textColor: Colors.black,
                                              fontSize: 20.0)
                                          .toString();
                                    } else if (_panCard.text.length != 10) {
                                      Fluttertoast.showToast(
                                              msg:
                                                  "Please enter a valid Pan Card number before selecting image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: MyColors.yellow,
                                              textColor: Colors.black,
                                              fontSize: 20.0)
                                          .toString();
                                    } else {
                                      pickFromCamera(panFrontPicProvider);
                                    }
                                  },
                                  child: Container(
                                    height: _height / 15,
                                    width: _width / 3,
                                    margin:
                                        EdgeInsets.only(top: 20.0, right: 10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      border:
                                          Border.all(color: MyColors.pureblack),
                                    ),
                                    child: Text(
                                      "Camera",
                                      style: MyTextStyle.button1,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_panCard.text.isEmpty) {
                                      Fluttertoast.showToast(
                                              msg:
                                                  "Please enter your Pan Card number before selecting image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: MyColors.yellow,
                                              textColor: Colors.black,
                                              fontSize: 20.0)
                                          .toString();
                                      return;
                                    } else if (_panCard.text.length != 10) {
                                      Fluttertoast.showToast(
                                              msg:
                                                  "Please enter a valid Pan Card number before selecting image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: MyColors.yellow,
                                              textColor: Colors.black,
                                              fontSize: 20.0)
                                          .toString();
                                      return;
                                    } else {
                                      pickFromGallery(panFrontPicProvider);
                                    }
                                  },
                                  child: Container(
                                    height: _height / 15,
                                    width: _width / 3,
                                    margin:
                                        EdgeInsets.only(top: 20.0, left: 10.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      color: MyColors.yellow,
                                    ),
                                    child: Text(
                                      "Browse",
                                      style: MyTextStyle.button1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () => ref.refresh(panFrontPicProvider),
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                  color: Colors.deepPurple,
                                  child: Image.file(panFrontPic,
                                      fit: BoxFit.cover)),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    color: MyColors.red,
                                  ))
                            ],
                          ),
                        ),
                      );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                child: Consumer(builder: (context, ref, child) {
                  File? panBackPic = ref.watch(panBackPicProvider);
                  return panBackPic == null
                      ? Container(
                          margin: EdgeInsets.all(
                            20.0,
                          ),
                          width: _width,
                          child: Column(
                            children: [
                              Text(
                                "Upload your PAN card back photo",
                                style: MyTextStyle.text4,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Icon(
                                Icons.image_outlined,
                                color: MyColors.pureblack,
                                size: 30.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_panCard.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Pan Card number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else if (_panCard.text.length != 10) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Pan Card number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                      } else {
                                        pickFromCamera(panBackPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, right: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        border: Border.all(
                                            color: MyColors.pureblack),
                                      ),
                                      child: Text(
                                        "Camera",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_panCard.text.isEmpty) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter your Pan Card number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else if (_panCard.text.length != 10) {
                                        Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid Pan Card number before selecting image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    MyColors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 20.0)
                                            .toString();
                                        return;
                                      } else {
                                        pickFromGallery(panBackPicProvider);
                                      }
                                    },
                                    child: Container(
                                      height: _height / 15,
                                      width: _width / 3,
                                      margin: EdgeInsets.only(
                                          top: 20.0, left: 10.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        color: MyColors.yellow,
                                      ),
                                      child: Text(
                                        "Browse",
                                        style: MyTextStyle.button1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => ref.refresh(panBackPicProvider),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                    color: Colors.deepPurple,
                                    child: Image.file(panBackPic,
                                        fit: BoxFit.cover)),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.cancel_rounded,
                                      color: MyColors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateForm() {
    if (_fullName.text.isEmpty) {
      showSnack('Name Should not be empty');
      return false;
    } else if (_shopNo.text.isEmpty) {
      showSnack('Shop Number Should not be empty');
      return false;
    } else if (_street.text.isEmpty) {
      showSnack('Street Should not be empty');
      return false;
    } else if (_city.text.isEmpty) {
      showSnack('City not be empty');
      return false;
    } else if (_landMark.text.isEmpty) {
      showSnack('Landmark Should not be empty');
      return false;
    } else if (_pincode.text.isEmpty) {
      showSnack('Street Should not be empty');
      return false;
    } else if (ref.watch(profilePicProvider) == null) {
      showSnack('Please select your Profile Picture');
      return false;
    } else if (ref.watch(aadhaarFrontPicProvider) == null) {
      showSnack('Please select your aadhaar card');
      return false;
    } else if (ref.watch(aadhaarBackPicProvider) == null) {
      showSnack('Please select your aadhaar card');
      return false;
    } else if (ref.watch(panFrontPicProvider) == null) {
      showSnack('Please select your Pan card');
      return false;
    } else if (ref.watch(aadhaarBackPicProvider) == null) {
      showSnack('Please select your Pan card');
      return false;
    }
    return true;
  }

  void pickSinglePic(dynamic provider) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose from a source',
                  style: MyTextStyle.formLabel,
                ),
              ],
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    pickFromCamera(provider);
                  },
                  child: CircleAvatar(
                      child: Icon(Icons.camera_alt,
                          color: MyColors.pureblack, size: 30),
                      backgroundColor: MyColors.yellow,
                      radius: 40),
                ),
                GestureDetector(
                  onTap: () {
                    pickFromGallery(provider);
                  },
                  child: CircleAvatar(
                      child: Icon(Icons.image,
                          color: MyColors.pureblack, size: 30),
                      backgroundColor: MyColors.yellow,
                      radius: 40),
                ),
              ],
            ),
          );
        });
  }

  void pickFromCamera(dynamic provider) async {
    if (provider == profilePicProvider) {
      Navigator.pop(context);
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      ref.read(provider.notifier).state = File(image.path);
    }
    print(image);
  }

  void pickFromGallery(dynamic provider) async {
    if (provider == profilePicProvider) {
      Navigator.pop(context);
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(provider.notifier).state = File(image.path);
    }
    print(image);
  }

  uploadFile(File file) async {
    return await AwsS3.uploadFile(file: file);
  }

  showSnack(String msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
      fontSize: 15.0);

  void uploadImages() {}
}
