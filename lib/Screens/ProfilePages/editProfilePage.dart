import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/provider/currentState.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final TextEditingController _fullName = TextEditingController();
  static TextEditingController _shopName = TextEditingController();

  // final _shopName = 'name';
  final TextEditingController _shopDescription = TextEditingController();

  // final TextEditingController _servicePrice = TextEditingController();
  final TextEditingController _shopNo = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  final _picker = ImagePicker();
  bool uploading = false;
  List<Asset> images = <Asset>[];
  List carouselImages = [];
  List removeImages = [];
  File profileImageUrl;
  String profileImageLink;
  List services = [];
  var _error = 'no error was detected';
  final _storage = FirebaseStorage.instance;

  @override
  void initState() {
    services.clear();
    images.clear();
    final _ProfilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    var data = _ProfilePageProvider.profileData;

    setState(() {
      removeImages.clear();
      _fullName.text = data['fullName'];
      _pincode.text = data['address']['pincode'];
      _city.text = data['address']['city'];
      _street.text = data['address']['street'];
      _shopName.text = data['shopName'];
      _shopNo.text = data['address']['shopNo'];
      _shopDescription.text = data['description'];
      profileImageLink = data['shopImages']['profile'];
      _state.text = data['address']['state'];
      carouselImages = data['shopImages']['carouselImages'];
    });
    // TODO: implement initState
    super.initState();
  }

  singleImagePicker({type = 'camera'}) async {
    PickedFile image;
    //Check Permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      if (type == 'gallery') {
        image = await _picker.getImage(
            source: ImageSource.gallery, imageQuality: 25);
      } else {
        image = await _picker.getImage(
            source: ImageSource.camera, imageQuality: 25);
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
    if (removeImages != null) {
      for (int i = 0; i <= removeImages.length - 1; i++) {
        await _storage.refFromURL(removeImages[i]).delete();
      }
    }
    if (profileImageUrl != null) {
      await _storage.refFromURL(profileImageLink).delete();
      profileImageLink = '';
      snapshot = await _storage
          .ref()
          .child('shop/$loginId/profileImage/profile}')
          .putFile(profileImageUrl);
      profileImageLink = await snapshot.ref.getDownloadURL();
    }
    if (images != null) {
      for (int i = carouselImages.length; i <= images.length - 1; i++) {
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
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    final _ProfilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.pureblack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile Page",
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
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
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
                                      ? CircleAvatar(
                                          radius: 60,
                                          backgroundImage:
                                              NetworkImage(profileImageLink),
                                          backgroundColor: Colors.transparent,
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
                            : Container(
                                margin: EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    "Edit your image",
                                    style: MyTextStyle.formSubHeading,
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
                                          height: 20,
                                        ),
                                        carouselImages.length == 0
                                            ? Container()
                                            : Container(
                                                height: size.height / 4,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        carouselImages.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Stack(children: [
                                                        Image.network(
                                                            carouselImages[
                                                                index]),
                                                        Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    removeImages.add(
                                                                        carouselImages[
                                                                            index]);
                                                                    carouselImages
                                                                        .remove(
                                                                            carouselImages[index]);
                                                                  });
                                                                },
                                                                icon: Icon(Icons
                                                                    .clear)))
                                                      ]);
                                                    }),
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              shopTypeGrid(),
                              Consumer<ProfilePageProvider>(
                                builder: (context, instance, W) {
                                  return brands.containsKey(
                                          _ProfilePageProvider.selectedShopType)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  top: 20,
                                                  bottom: 20),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${_ProfilePageProvider.selectedShopType} Brands",
                                                style: MyTextStyle.formLabel,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 20, left: 20),
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              150,
                                                          childAspectRatio:
                                                              2 / 2,
                                                          crossAxisSpacing: 15,
                                                          mainAxisSpacing: 15),
                                                  itemCount: brands[_ProfilePageProvider
                                                                  .selectedShopType]
                                                              .length ==
                                                          0
                                                      ? 0
                                                      : brands[_ProfilePageProvider
                                                              .selectedShopType]
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          index) {
                                                    String shopType =
                                                        _ProfilePageProvider
                                                            .selectedShopType;
                                                    var selected = false;
                                                    if (_ProfilePageProvider
                                                        .selectedShopsBrands
                                                        .containsKey(
                                                            shopType)) {
                                                      List a = _ProfilePageProvider
                                                              .selectedShopsBrands[
                                                          shopType];
                                                      if (a.contains(
                                                          brands[shopType]
                                                              [index])) {
                                                        selected = true;
                                                      }
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (!selected) {
                                                          selected = !selected;
                                                          _ProfilePageProvider
                                                              .brandTypeAdd(
                                                                  brands[shopType]
                                                                      [index]);
                                                        } else {
                                                          selected = !selected;
                                                          _ProfilePageProvider
                                                              .brandTypeRemove(
                                                                  brands[shopType]
                                                                      [index]);
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          brands[shopType]
                                                                  [index]
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: MyColors
                                                                .pureblack,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: selected
                                                                ? Color(
                                                                    0xffF5CA37)
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        )
                                      : Container();
                                },
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
                        GestureDetector(
                          onTap: () {
                            if (_fullName.text.isEmpty |
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
                            } else if (_ProfilePageProvider
                                    .shopTypeList.length <
                                1) {
                              Fluttertoast.showToast(
                                  msg: "Please Select atleast 1 ShopType",
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
                            } else if (
                                // (profileImageLink != '') &
                                (_fullName.text.length > 2) &
                                    (_shopName.text.length > 2) &
                                    (_shopDescription.text.length > 2) &
                                    (_shopNo.text.length > 0) &
                                    (_street.text.length > 2) &
                                    (_city.text.length > 0) &
                                    (_state.text.length > 2) &
                                    (_pincode.text.length > 5)) {
                              setState(() {
                                uploading = true;
                              });
                              Fluttertoast.showToast(
                                  msg: "Data is saved please check it once...",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.yellow,
                                  textColor: Colors.black,
                                  fontSize: 15.0);

                              final _ProfilePageProvider =
                                  Provider.of<ProfilePageProvider>(context,
                                      listen: false);

                              insertImage().then((value) =>
                                  _ProfilePageProvider.updateProfile({
                                    'fullName': _fullName.value.text,
                                    'shopName': _shopName.value.text,
                                    'description': _shopDescription.value.text,
                                    'shopImages': {
                                      'profile': profileImageLink,
                                      'carouselImages': carouselImages
                                    },
                                    'address': {
                                      'city': _city.value.text,
                                      'pincode': _pincode.value.text,
                                      'shopNo': _shopNo.value.text,
                                      'state': _state.value.text,
                                      'street': _street.value.text
                                    }
                                  }).then((d) {
                                    setState(() {
                                      uploading = false;
                                    });
                                    Navigator.of(context).pop();
                                  }));
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
                  ),
                ),
                Visibility(
                  visible: uploading,
                  child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lotties/uploading.json',
                              width: size.width * 0.5),
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

  @override
  void dispose() {
    removeImages.clear();
    images.clear();
    carouselImages.clear();
    super.dispose();
  }
}

class shopTypeGrid extends StatelessWidget {
  List shopType = [
    'Car',
    'Cycle',
    'Bike',
    'Truck',
    'Laptop',
    'Mobile',
    'Printer',
    'Television',
    'Water Purifier',
    'Refrigerator',
    'AC',
    'Washing Machine',
    'Microwave',
    'Rickshaw',
    'Chimney',
    'Grinder',
    'Inverter',
    'Watch'
  ];

  @override
  Widget build(BuildContext context) {
    final _ProfilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    _ProfilePageProvider.getShopType();

    var data = _ProfilePageProvider.shopTypeList;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: shopType.length,
          itemBuilder: (BuildContext ctx, index) {
            var selected = false;
            if (data.contains(shopType[index])) {
              selected = true;
            }
            return Consumer<ProfilePageProvider>(
              builder: (context, V, W) => GestureDetector(
                onTap: () {
                  if (selected) {
                    selected = !selected;
                    _ProfilePageProvider.removeShopType(shopType[index]);
                  } else {
                    selected = !selected;
                    _ProfilePageProvider.addShopType(shopType[index]);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    shopType[index],
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: selected ? Color(0xffF5CA37) : Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            );
          }),
    );
  }
}
