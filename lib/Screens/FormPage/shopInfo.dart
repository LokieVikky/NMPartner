import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:partner/Screens/FormPage/form.dart';
import 'package:partner/models/garage/sub_models/addressModel.dart';
import 'package:partner/models/mModel/modelService.dart';

import '../../aws/aws_storage.dart';
import '../../entity/shopInfoEntity.dart';
import '../../provider/mProvider/commanProviders.dart';
import '../../provider/mProvider/currentStepProvider.dart';
import '../../provider/mProvider/imageProvider.dart';
import '../../provider/mProvider/shopInfoProvider.dart';
import '../../services/apiService.dart';
import '../../state/ShopState.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class ShopInfo extends ConsumerStatefulWidget {
  const ShopInfo({Key? key}) : super(key: key);

  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends ConsumerState<ShopInfo> {
  static TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopDescription = TextEditingController();

  final TextEditingController _shopNo = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _landMark = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  List<Asset> images = <Asset>[];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> brandList = [];
  final _picker = ImagePicker();
  File? shopPic;
  AddressModel? shopAddress = null;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: 10.0,
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
                      bottom: 10.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Address",
                          style: MyTextStyle.formLabel,
                        ),
                        GestureDetector(
                            onTap: () => showMap(_width, _height),
                            child: Icon(Icons.location_searching))
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
                      controller: _shopDescription,
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
                  SizedBox(
                    height: 20.0,
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
                          shopPic = ref.watch(shopPicProvider);
                          return shopPic == null
                              ? Container(
                                  margin: EdgeInsets.all(
                                    20.0,
                                  ),
                                  width: _width,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Upload your Shop photo",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              pickFromCamera(shopPicProvider);
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
                                              pickFromGallery(shopPicProvider);
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
                                  onTap: () => ref.refresh(shopPicProvider),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Container(
                                            color: Colors.deepPurple,
                                            child: Image.file(shopPic!,
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
                ],
              ),
            ),
            StreamBuilder(
              builder: (context, snapshot) {
                ShopState state = ref.watch(shopInfoNotifierProvider);
                switch (state.status) {
                  case UpdateShopStatus.initial:
                  case UpdateShopStatus.success:
                  case UpdateShopStatus.failure:
                    return GestureDetector(
                      onTap: () {
                        if (validateForm()) {
                          ref
                              .read(shopInfoNotifierProvider.notifier)
                              .setLoadingState();
                          uploadShop();
                        }
                      },
                      child: Container(
                        height: _height / 15,
                        width: _width,
                        margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 5.0,
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
                    );
                  case UpdateShopStatus.loading:
                    return Container(
                      height: _height / 15,
                      width: _width,
                      margin: EdgeInsets.only(
                        top: 10.0,
                        bottom: 5.0,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: MyColors.yellow,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                            color: MyColors.pureblack, strokeWidth: 2),
                      ),
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  getSelectionItem(int index, String name, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: MyColors.pureblack,
          fontFamily: 'Poppins',
        ),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
          color: isSelected ? MyColors.yellow : Colors.white,
          borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget getServiceItem(ModelService item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Container(
            height: 60,
            color: MyColors.yellow,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      item.name.toString(),
                      style: MyTextStyle.button2,
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      '500',
                      style: MyTextStyle.button1,
                    )),
                Expanded(child: Icon(Icons.add))
              ],
            ),
          ),
          Visibility(child: Container())
        ],
      ),
    );
  }

  bool validateForm() {
    if (shopAddress == null) {
      showSnack('please mark your shop in map');
      return false;
    } else if (_shopName.text.isEmpty) {
      showSnack('shop name should not be empty');
      return false;
    } else if (_shopNo.text.isEmpty) {
      showSnack('shop no should not be empty');
      return false;
    } else if (_street.text.isEmpty) {
      showSnack('street name should not be empty');
      return false;
    } else if (_city.text.isEmpty) {
      showSnack('city should not be empty');
      return false;
    } else if (_pincode.text.isEmpty) {
      showSnack('pincode should not be empty');
      return false;
    } else if (_landMark.text.isEmpty) {
      showSnack('landmark should not be empty');
      return false;
    } else if (_shopDescription.text.isEmpty) {
      showSnack('shop description should not be empty');
      return false;
    } else if (shopPic == null) {
      showSnack('image should not be empty');
      return false;
    }
    return true;
  }

  void pickFromCamera(dynamic provider) async {
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

  void uploadShop() async {
    String shopAvatarUrl = await uploadFile(ref.watch(shopPicProvider)!);
    ShopEntity shop = ShopEntity(
        shopName: _shopName.text,
        shopDescription: _shopDescription.text,
        shopNo: _shopNo.text,
        street: _street.text,
        city: _city.text,
        pincode: _pincode.text,
        avatarUrl: shopAvatarUrl,
        latlng:
            shopAddress!.lat.toString() + "," + shopAddress!.long.toString(),
        partnerId: await ApiService().readPartnerId(),
        landmark: _landMark.text);

    await ref.read(shopInfoNotifierProvider.notifier).insertShopInfo(shop);
    ShopState result = ref.watch(shopInfoNotifierProvider);
    ApiService().saveToken(shopId: result.data!.value!.shopId!);

    if (result != null && result.data != null) {
      result.data!.when(
          data: (data) {
            if (data != null) {
              if (data.shopId!.isNotEmpty) {
                ref.read(currentStepNotifierProvider.notifier).getCurrentStep();
              }
            }
          },
          error: (err, errTxt) {
            showSnack(err.toString());
          },
          loading: () {});
    }
  }

  uploadFile(File file) async {
    return await AwsS3.uploadFile(file: file);
  }

  showMap(double width, double height) {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            LatLng latlng = ref.watch(markerProvider);
            final CameraPosition _kGooglePlex = CameraPosition(
              target: latlng,
              zoom: 12,
            );
            return Stack(
              children: [
                GoogleMap(
                  markers: Set<Marker>.of([
                    Marker(
                      markerId: MarkerId(_kGooglePlex.toString()),
                      position: latlng,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    )
                  ]),
                  initialCameraPosition: _kGooglePlex,
                  onTap: (point) {
                    setMarker(point);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            var newPlace = await placemarkFromCoordinates(
                                latlng.latitude, latlng.longitude);
                            Placemark placeMark = newPlace[0];
                            String? name = placeMark.name;
                            String? subLocality = placeMark.subLocality;
                            String? locality = placeMark.locality;
                            String? administrativeArea =
                                placeMark.administrativeArea;
                            String? postalCode = placeMark.postalCode;
                            String? country = placeMark.country;

                            Navigator.pop(context);
                            shopAddress = AddressModel(
                                street: subLocality,
                                city: locality,
                                pincode: postalCode,
                                lat: latlng.latitude,
                                long: latlng.longitude);

                            _street.text = subLocality!;
                            _city.text = locality!;
                            _pincode.text = postalCode!;
                          },
                          child: Text("SAVE")),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  void setMarker(LatLng point) {
    ref.read(markerProvider.notifier).state = point;
  }
}
