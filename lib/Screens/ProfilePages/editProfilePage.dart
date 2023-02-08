import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/entity/ProfileEntity.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/mProvider/imageProvider.dart';
import '../../provider/mProvider/profilePictureProvider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  ProfileEntity? profileEntity;

  EditProfilePage(this.profileEntity, {Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _partnerFullName = TextEditingController();
  final TextEditingController _partnerContactNumber = TextEditingController();
  final TextEditingController _partnerHouseNo = TextEditingController();
  final TextEditingController _partnerStreet = TextEditingController();
  final TextEditingController _partnerCity = TextEditingController();
  final TextEditingController _partnerPincode = TextEditingController();
  final TextEditingController _partnerLandmark = TextEditingController();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopDescription = TextEditingController();
  final TextEditingController _shopNo = TextEditingController();
  final TextEditingController _shopStreet = TextEditingController();
  final TextEditingController _shopCity = TextEditingController();
  final TextEditingController _shopPincode = TextEditingController();
  final TextEditingController _shopLandmark = TextEditingController();


  @override
  void initState() {
    () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? phoneNumber = await pref.getString('prefPhone');
      PartnerInfoEntity partnerInfoEntity =
       widget.profileEntity!.partnerInfoEntity!;
      _partnerFullName.text = partnerInfoEntity.partnerName!;
      _partnerContactNumber.text = phoneNumber!;
      _partnerHouseNo.text = partnerInfoEntity.partnerFlatNo!;
      _partnerStreet.text = partnerInfoEntity.partnerStreet!;
      _partnerCity.text = partnerInfoEntity.partnerCity!;
      _partnerPincode.text = partnerInfoEntity.partnerPincode!;
      _partnerLandmark.text = partnerInfoEntity.partnerLandmark!;

      ShopEntity shopEntity = widget.profileEntity!.shopEntity!;
      _shopName.text = shopEntity.shopName!;
      _shopDescription.text = shopEntity.shopDescription!;
      _shopNo.text = shopEntity.shopNo!;
      _shopStreet.text = shopEntity.street!;
      _shopCity.text = shopEntity.city!;
      _shopPincode.text = shopEntity.pincode!;
      _shopLandmark.text = shopEntity.landmark!;
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purewhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.pureblack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile Page",
          style: MyTextStyle.text1,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      /*_Your_Profile_*/
                      Container(
                        margin: EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        child: Center(
                          child: Text(
                            "Your profile",
                            style: MyTextStyle.formHeading,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
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
                                controller: _partnerFullName,
                                maxLength: 70,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
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
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Contact numbers",
                                style: MyTextStyle.formLabel,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _partnerContactNumber,
                                maxLength: 70,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
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
                        padding:
                            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 20.0,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Your Address",
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
                                      controller: _partnerHouseNo,
                                      maxLength: 4,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                                      controller: _partnerStreet,
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          controller: _partnerCity,
                                          maxLength: 50,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.name,
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          controller: _partnerPincode,
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
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
                                      controller: _partnerLandmark,
                                      keyboardType: TextInputType.name,
                                      maxLength: 25,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                      /*_Shop_Profile_*/
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: Center(
                          child: Text(
                            "Shop profile",
                            style: MyTextStyle.formHeading,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Shop name",
                                style: MyTextStyle.formLabel,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _shopName,
                                maxLength: 50,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
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
                          left: 20.0,
                          right: 20.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Description",
                                style: MyTextStyle.formLabel,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                maxLines: 7,
                                maxLength: 1000,
                                minLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                controller: _shopDescription,
                                keyboardType: TextInputType.name,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.yellow,
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
                        padding:
                            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 20.0,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Shop Address",
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
                                      "Shop no.",
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                                      controller: _shopStreet,
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          controller: _shopCity,
                                          maxLength: 50,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.name,
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          controller: _shopPincode,
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          decoration: new InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.yellow,
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
                                      controller: _shopLandmark,
                                      keyboardType: TextInputType.name,
                                      maxLength: 25,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.yellow,
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
                      GestureDetector(
                        onTap: () async {
                          if(_formKey.currentState!.validate()) {
                            ShopEntity sEntity = ShopEntity(
                              pincode: _shopPincode.text,
                              landmark: _shopLandmark.text,
                              city: _shopCity.text,
                              street: _shopStreet.text,
                              shopNo: _shopNo.text,
                              shopName: _shopName.text,
                              shopDescription: _shopDescription.text,
                            );

                            PartnerInfoEntity pEntity = PartnerInfoEntity(
                              partnerPincode: _partnerPincode.text,
                              partnerCity: _partnerCity.text,
                              partnerStreet: _partnerStreet.text,
                              partnerFlatNo: _partnerHouseNo.text,
                              partnerLandmark: _partnerLandmark.text,
                              partnerName: _partnerFullName.text,
                            );

                            ProfileEntity entity = ProfileEntity(
                              shopEntity: sEntity,
                              partnerInfoEntity: pEntity,
                            );

                            var res = await ref.read(profileNotifierProvider.notifier).updateProfile(entity);
                            if(res != null) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Container(
                          height: _height / 15,
                          width: _width,
                          margin: EdgeInsets.only(
                            top: 20.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 30.0,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: AppColors.yellow,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
