import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:partner/Screens/FormPage/widgets/selectedService.dart';
import 'package:partner/provider/currentState.dart';
import 'package:partner/provider/form_provider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _fullName = TextEditingController();
  static TextEditingController _shopName = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  // final _shopName = 'name';
  final TextEditingController _shopDescription = TextEditingController();

  // final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _shopNo = TextEditingController();
  final TextEditingController _priceRate = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _otherName = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panCard = TextEditingController();
  final _picker = ImagePicker();
  List<Asset> images = <Asset>[];
  List carouselImages = [];
  File profileImageUrl;
  String profileImageLink;
  List services = [];
  var _error = 'no error was detected';
  final _storage = FirebaseStorage.instance;
  Map brands = {
    '': [],
    'Bike': [
      'suzuki',
      'yamaha',
      'benelli',
      'revolt',
      'ducati',
      'jawa',
      'husqvarna',
      'honda',
      'bmw',
      'ktm',
      'kawasaki',
      'hyosung',
      'bajaj',
      'hero',
      'aprillia',
      'royal-enfield',
      'tvs'
    ],
    'Car': [
      'chevrolet',
      'tata',
      'volvo',
      'mahindra',
      'kia',
      'fiat',
      'force',
      'maruti',
      'landrover',
      'nissan',
      'jeep',
      'ashok',
      'toyota',
      'mercedes',
      'audi',
      'volkswagen',
      'mg',
      'skoda',
      'hyundai',
      'honda',
      'datsun',
      'renault',
      'others',
      'ford',
      'range'
    ],
    'Laptop': ['toshiba', 'dell', 'hp', 'iball', 'msi', 'acer', 'lenovo'],
    'Mobile': [
      'htc',
      'apple',
      'honor',
      'karbonn',
      'huawei',
      'lyf',
      'sony',
      'oppo',
      'google',
      'poco',
      'nokia',
      'oneplus',
      'coolpad',
      'xiaomi',
      'asus',
      'intex',
      'samsung',
      'lg',
      'lava',
      'micromax',
      'blackberry',
      'motorola',
      'vivo'
    ],
    'Television': [
      'bpl',
      'hisense',
      'huawei',
      'mi',
      'micromax',
      'motorola',
      'onida',
      'philips',
      'sansui',
      'sony',
      'tci',
      'thomson',
      'vu',
      'others'
    ],
    'Grinder': [
      'bajaj',
      'butterfly',
      'philips',
      'preethi',
      'prestige',
      'others'
    ],
    'AC': [
      'bluestar',
      'carrier',
      'daikin',
      'haier',
      'hitachi',
      'lg',
      'general',
      'sanyo',
      'others'
    ],
    'Refrigerator': [
      'bosch',
      'electrolux',
      'godrej',
      'haier',
      'lg',
      'panasonic',
      'samsung',
      'siemens',
      'videcon',
      'voltas',
      'whirlpool',
      'others'
    ],
    'Washing Machine': [
      'bosch',
      'bpl',
      'godrej',
      'haier',
      'ifb',
      'intex',
      'lg',
      'onida',
      'panasonic',
      'samsung',
      'videocon',
      'whirlpool',
      'others'
    ]
  };
  bool uploading = false;

  @override
  void initState() {
    services.clear();
    images.clear();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullName.dispose();
    _shopName.dispose();
    _shopDescription.dispose();
    _shopNo.dispose();
    _priceRate.dispose();
    _street.dispose();
    _city.dispose();
    _pincode.dispose();
    _otherName.dispose();
    services.clear();
    _aadhaarController.dispose();
    _panCard.dispose();
    images.clear();
    super.dispose();
  }

  String serviceName = 'Batteries';
  List<String> serviceList = [
    'Batteries',
    'Denting & Painting',
    //'app',
    'other'
  ];
  String aadharLink;
  File aadharCardImage;

  String pancardLink;
  File pancardimageURL;

  singleImagePicker({type = 'camera'}) async {
    PickedFile image;
    //Check Permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      if (type == 'gallery') {
        image = await _picker.getImage(source: ImageSource.gallery,imageQuality: 25);
      } else {
        image = await _picker.getImage(source: ImageSource.camera,imageQuality: 25);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Permission not granted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
    return image;
  }

  profileImage() async {
    PickedFile image = await singleImagePicker();
    if (image != null) {
      var file = File(image.path);

      setState(() {
        profileImageUrl = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Image not Selected or found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  shopImagesPicker() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#30324C",
          actionBarTitle: "Namma Mechanics",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future insertImage() async {
    final _currentProvider = Provider.of<CurrentState>(context, listen: false);
    String loginId = _currentProvider.prefs.getString('loginID');
    var snapshot;
    //Upload to firebase
    profileImageLink = '';
    carouselImages.clear();
    snapshot = await _storage
        .ref()
        .child('shop/$loginId/profileImage/${_shopName.text.toString()}')
        .putFile(profileImageUrl);

    profileImageLink = await snapshot.ref.getDownloadURL();
    snapshot = await _storage
        .ref()
        .child('shop/'
            '$loginId/verificationDocuments/aadharCard')
        .putFile(aadharCardImage);

    aadharLink = await snapshot.ref.getDownloadURL();
    snapshot = await _storage
        .ref()
        .child('shop/$loginId/verificationDocuments/panCard')
        .putFile(pancardimageURL);

    pancardLink = await snapshot.ref.getDownloadURL();

    for (int i = 0; i <= images.length - 1; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var snapshot = await _storage
          .ref()
          .child('shop/$loginId/carouselImages/${i.toString()}')
          .putFile(File(path));
      //
      var downloadUrl = await snapshot.ref.getDownloadURL();
      carouselImages.add(downloadUrl);
    }
  }

  uploadImage(type) async {
    PickedFile image = await singleImagePicker(type: type);
    var file = File(image.path);
    if (image != null) {
      //Upload to firebase
      setState(() {
        aadharCardImage = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Aadhaar Card Image not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 20.0);
    }
  }

  panImage(type) async {
    PickedFile image = await singleImagePicker(type: type);

    var file = File(image.path);
    if (image != null) {
      //Upload to firebase
      setState(() {
        pancardimageURL = file;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Pan Card Image not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentState _instance = Provider.of<CurrentState>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    final formProvider = Provider.of<FormProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Form Page",
          style: MyTextStyle.text1,
        ),
      ),
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
            physics: uploading == true
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 20.0,
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
                            bottom: 10.0,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_shopName.text.length > 2) {
                                  profileImage();
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please Enter shop name before selecting profile image",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.yellow,
                                      textColor: Colors.black,
                                      fontSize: 15.0);
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 115,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: MyColors.purple),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  profileImageUrl == null
                                      ? Column(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: MyColors.purple,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: MyColors.purewhite,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundImage:
                                              FileImage(profileImageUrl),
                                          backgroundColor: Colors.transparent,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                        profileImageUrl == null
                            ? Container(
                                margin: EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    "Upload your image",
                                    style: MyTextStyle.formSubHeading,
                                  ),
                                ),
                              )
                            : Container(),
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
                                height: 10.0,
                              ),
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                padding: EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(
                                      20.0,
                                    ),
                                    width: _width,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Upload your photo",
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
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () => shopImagesPicker(),
                                              child: Container(
                                                height: _height / 15,
                                                width: _width / 3,
                                                margin: EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 10.0,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                  border: Border.all(
                                                      color:
                                                          MyColors.pureblack),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Camera",
                                                    style: MyTextStyle.button1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => shopImagesPicker(),
                                              child: Container(
                                                height: _height / 15,
                                                width: _width / 3,
                                                margin: EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 10.0,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                        images.length == 0
                                            ? Container()
                                            : Container(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                height: _height / 3,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: List.generate(
                                                      images.length, (index) {
                                                    Asset asset = images[index];
                                                    return AssetThumb(
                                                      asset: asset,
                                                      width: 300,
                                                      height: 300,
                                                    );
                                                  }),
                                                ),
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Select shop type",
                                        style: MyTextStyle.formLabel,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SelectedService(
                                          selectedService: "Car",
                                        ),
                                        SelectedService(
                                          selectedService: "Cycle",
                                        ),
                                        SelectedService(
                                          selectedService: "Bike",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SelectedService(
                                          selectedService: "Truck",
                                        ),
                                        SelectedService(
                                          selectedService: "Mobile",
                                        ),
                                        SelectedService(
                                          selectedService: "Printer",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SelectedService(
                                          selectedService: "Refrigerator",
                                        ),
                                        SelectedService(
                                          selectedService: "AC",
                                        ),
                                        SelectedService(
                                          selectedService: "Washing Machine",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectedService(
                                          selectedService: "Microwave",
                                        ),
                                        SelectedService(
                                          selectedService: "Chimney",
                                        ),
                                        SelectedService(
                                          selectedService: "Rickshaw",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectedService(
                                          selectedService: "Water Purifier",
                                        ),
                                        SelectedService(
                                          selectedService: "Laptop",
                                        ),
                                        SelectedService(
                                          selectedService: "Television",
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectedService(
                                          selectedService: "Grinder",
                                        ),
                                        SelectedService(
                                          selectedService: "Inverter",
                                        ),
                                        SelectedService(
                                          selectedService: "Watch",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        brands.containsKey(formProvider.selectedShopType)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 20, bottom: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${formProvider.selectedShopType} Brands",
                                      style: MyTextStyle.formLabel,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 150,
                                                childAspectRatio: 2 / 2,
                                                crossAxisSpacing: 15,
                                                mainAxisSpacing: 15),
                                        itemCount: brands[formProvider
                                                        .selectedShopType]
                                                    .length ==
                                                0
                                            ? 0
                                            : brands[formProvider
                                                    .selectedShopType]
                                                .length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          String shopType =
                                              formProvider.selectedShopType;
                                          var selected = false;
                                          if (formProvider.selectedShopsBrands
                                              .containsKey(shopType)) {
                                            List a = formProvider
                                                .selectedShopsBrands[shopType];
                                            if (a.contains(
                                                brands[shopType][index])) {
                                              selected = true;
                                            }
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              if (!selected) {
                                                selected = !selected;
                                                formProvider.brandTypeAdd(
                                                    brands[shopType][index]);
                                              } else {
                                                selected = !selected;
                                                formProvider.brandTypeRemove(
                                                    brands[shopType][index]);
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                brands[shopType][index]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyColors.pureblack,
                                                  fontFamily: 'Poppins',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: selected
                                                      ? Color(0xffF5CA37)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20,
                                  left: 20.0,
                                  bottom: 20.0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Shop services",
                                  style: MyTextStyle.formLabel,
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
                                      margin: EdgeInsets.only(
                                        bottom: 8,
                                        top: 20,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Select Service",
                                        style: MyTextStyle.formLabel,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          right: 20,
                                          left: 20),
                                      decoration: BoxDecoration(
                                        // color: Colors.teal,
                                        border: Border.all(
                                            color: Colors.black12,
                                            style: BorderStyle.solid),
                                      ),
                                      width: _width,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: serviceName,
                                          items: serviceList.length == 0
                                              ? []
                                              : serviceList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              serviceName = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    if (serviceName != 'other')
                                      Container()
                                    else ...[
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: 8,
                                          top: 20,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Service Name",
                                          style: MyTextStyle.formLabel,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _otherName,
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
                                      )
                                    ],
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Price rate",
                                        style: MyTextStyle.formLabel,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _priceRate,
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
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 30.0,
                                      ),
                                      height: _height / 15,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: MyColors.purple2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          if (_priceRate.value.text.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: "Price Field is Empty",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.yellow,
                                                textColor: Colors.black,
                                                fontSize: 15.0);
                                          } else {
                                            bool exists = false;
                                            services.forEach((v) => {
                                                  if (v['name'] == serviceName)
                                                    {exists = true}
                                                });
                                            if (!exists)
                                              setState(() {
                                                if (serviceName == 'other') {
                                                  if (_otherName
                                                      .value.text.isEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Name Field is empty",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.yellow,
                                                        textColor: Colors.black,
                                                        fontSize: 15.0);
                                                  } else
                                                    services.add({
                                                      'name':
                                                          _otherName.value.text,
                                                      'price':
                                                          _priceRate.value.text
                                                    });
                                                  _otherName.clear();
                                                } else {
                                                  services.add({
                                                    'name': serviceName,
                                                    'price': double.parse(
                                                        _priceRate.value.text)
                                                  });
                                                }
                                                _priceRate.clear();
                                              });
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "+ ADD",
                                            style: MyTextStyle.text15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Table(
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: services
                                              .map((index) =>
                                                  ServiceRow(index, _width))
                                              .toList(),
                                        ))
                                  ],
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
                                  left: 20.0,
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
                                  left: 20.0,
                                  right: 20.0,
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
                                  left: 20.0,
                                  right: 20.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
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
                                      right: 20.0,
                                      bottom: 20.0,
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "State",
                                            style: MyTextStyle.formLabel,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Container(
                                          width: _width * 0.4,
                                          child: TextFormField(
                                            controller: _state,
                                            keyboardType: TextInputType.name,
                                            maxLength: 17,
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
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Pincode",
                                        style: MyTextStyle.formLabel,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _pincode,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
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
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20.0,
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
                            left: 20.0,
                            right: 20.0,
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
                                  controller: _aadhaarController,
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
                        aadharCardImage == null
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(
                                        20.0,
                                      ),
                                      width: _width,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Upload your Aadhar photo",
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
                                                  if (_aadhaarController
                                                      .text.isEmpty) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter your Aadhaar number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else if (_aadhaarController
                                                          .text.length !=
                                                      12) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter a valid Aadhaar number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else {
                                                    uploadImage('camera');
                                                  }
                                                },
                                                child: Container(
                                                  height: _height / 15,
                                                  width: _width / 3,
                                                  margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 10.0,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0),
                                                    ),
                                                    border: Border.all(
                                                        color:
                                                            MyColors.pureblack),
                                                  ),
                                                  child: Text(
                                                    "Camera",
                                                    style: MyTextStyle.button1,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_aadhaarController
                                                      .text.isEmpty) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter your Aadhaar number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else if (_aadhaarController
                                                          .text.length !=
                                                      12) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter a valid Aadhaar number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else {
                                                    uploadImage('gallery');
                                                  }
                                                },
                                                child: Container(
                                                  height: _height / 15,
                                                  width: _width / 3,
                                                  margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 10.0,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 200.0,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(aadharCardImage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        pancardimageURL == null
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(
                                        20.0,
                                      ),
                                      width: _width,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Upload your PAN card photo",
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
                                                  if (_panCard.text.isEmpty) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter your Pan Card number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else if (_panCard
                                                          .text.length !=
                                                      10) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter a valid Pan Card number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else {
                                                    panImage('camera');
                                                  }
                                                },
                                                child: Container(
                                                  height: _height / 15,
                                                  width: _width / 3,
                                                  margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 10.0,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0),
                                                    ),
                                                    border: Border.all(
                                                        color:
                                                            MyColors.pureblack),
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
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else if (_panCard
                                                          .text.length !=
                                                      10) {
                                                    Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter a valid Pan Card number before selecting image",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                MyColors.yellow,
                                                            textColor:
                                                                Colors.black,
                                                            fontSize: 20.0)
                                                        .toString();
                                                  } else {
                                                    panImage('gallery');
                                                  }
                                                },
                                                child: Container(
                                                  height: _height / 15,
                                                  width: _width / 3,
                                                  margin: EdgeInsets.only(
                                                    top: 20.0,
                                                    left: 10.0,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                height: 200.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(pancardimageURL),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        GestureDetector(
                          onTap: () async {
                            if (profileImageUrl == null) {
                              Fluttertoast.showToast(
                                  msg: "Profile image is not yet selected",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (aadharCardImage == null) {
                              Fluttertoast.showToast(
                                  msg: "Aadhar Card image is not yet selected",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (pancardimageURL == null) {
                              Fluttertoast.showToast(
                                  msg: "Pan Card image is not yet selected",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_fullName.text.isEmpty |
                                (_fullName.text.length < 2)) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_shopName.text.isEmpty |
                                (_shopName.text.length < 2)) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid shop name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_shopDescription.text.isEmpty |
                                (_shopDescription.text.length < 10)) {
                              Fluttertoast.showToast(
                                  msg: "Description too short",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_shopDescription.text.isEmpty |
                                (_shopDescription.text.length < 10)) {
                              Fluttertoast.showToast(
                                  msg: "Description too short",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_shopNo.text.isEmpty &
                                (_shopNo.text == "0")) {
                              Fluttertoast.showToast(
                                  msg: "Description too short",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_street.text.isEmpty &
                                (_street.text.length < 3)) {
                              Fluttertoast.showToast(
                                  msg: "Enter valid street name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_city.text.isEmpty &
                                (_city.text.length < 3)) {
                              Fluttertoast.showToast(
                                  msg: "Enter valid city name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_state.text.isEmpty &
                                (_state.text.length < 3)) {
                              Fluttertoast.showToast(
                                  msg: "Enter valid state name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if (_pincode.text.isEmpty &
                                (_pincode.text.length < 6)) {
                              Fluttertoast.showToast(
                                  msg: "Enter valid pincode name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                            } else if ((profileImageUrl != null) &
                                (aadharCardImage != null) &
                                (pancardimageURL != null) &
                                (_fullName.text.length > 2) &
                                (_shopName.text.length > 2) &
                                (_shopDescription.text.length > 2) &
                                (_shopNo.text.length > 0) &
                                (_street.text.length > 2) &
                                (_city.text.length > 0) &
                                (_state.text.length > 2) &
                                (_pincode.text.length > 5) &
                                (services.length > 0)) {
                              Fluttertoast.showToast(
                                  msg: "Data is saved please check it once...",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
                              setState(() {
                                uploading = true;
                              });
                              await insertImage()
                                  .then((value) => formProvider.saveData(
                                      carouselImages: carouselImages,
                                      empDetails: [],
                                      formID: _instance.prefs.getString(
                                          'loginID'), // change when we get uid of login
                                      panCard: _panCard.text,
                                      panLink: pancardLink,
                                      aadharCard: _aadhaarController.text,
                                      aadharLink: aadharLink,
                                      fullName: _fullName.text,
                                      shopName: _shopName.text,
                                      description: _shopDescription.text,
                                      shopNo: _shopNo.text,
                                      street: _street.text,
                                      city: _city.text,
                                      state: _state.text,
                                      pincode: _pincode.text,
                                      profileImageURL: profileImageLink,
                                      services: services))
                                  .then((value) {
                                _instance.formVerified();
                                setState(() {
                                  uploading = false;
                                });
                                return Navigator.pushNamedAndRemoveUntil(
                                    context, '/homePage', (route) => false);
                              }).catchError((e) => Fluttertoast.showToast(
                                      msg: "Please please try again ",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.yellow,
                                      textColor: Colors.black,
                                      fontSize: 15.0));
                              setState(() {
                                uploading = false;
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please re-check all the field",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);
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
                    Positioned(
                      bottom: 1,
                      child: Visibility(
                        visible: uploading,
                        child: Center(
                          child: Container(
                              width: size.width,
                              height: size.height,
                              color: Colors.white60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/lotties/uploading.json',
                                      width: size.width * 0.5),
                                  Text(
                                      'Uploading Data Please wait and Don\'t Close the app')
                                ],
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow ServiceRow(value, width) {
    return TableRow(
      children: [
        Text(
          value['name'],
          style: MyTextStyle.formContainerNotSelected,
        ),
        Text(
          "₹ ${value['price'].toString()}",
          style: MyTextStyle.formContainerNotSelected,
        ),
        GestureDetector(
          onTap: () => setState(() {
            services.remove(value);
          }),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              border: Border.all(
                color: MyColors.red,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                "Remove",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: MyColors.red,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
