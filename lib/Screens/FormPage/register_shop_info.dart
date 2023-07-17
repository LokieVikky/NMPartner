import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:partner/Screens/FormPage/form.dart';
import 'package:partner/models/garage/sub_models/addressModel.dart';
import 'package:partner/models/mModel/nm_service.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/provider/update_partner_controller.dart';
import 'package:partner/provider/update_shop_controller.dart';
import 'package:partner/provider/upload_image_controller.dart';
import 'package:partner/shared/async_value_ui.dart';
import 'package:partner/shared/attached_image.dart';
import 'package:partner/shared/location_picker.dart';

import '../../entity/shopInfoEntity.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class RegisterShopInfo extends ConsumerStatefulWidget {
  const RegisterShopInfo({Key? key}) : super(key: key);

  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends ConsumerState<RegisterShopInfo> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopNoController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController latlngController = TextEditingController();
  final TextEditingController shopDescriptionController = TextEditingController();
  XFile? shopImg;
  late AttachedImage shopPhoto;

  @override
  void initState() {
    super.initState();
    shopPhoto = AttachedImage(shopImg);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      updateShopControllerProvider,
      (_, state) {
        if (state is AsyncData) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
        }
        ref.refresh(registrationStatusProvider);
        state.showSnackBarOnError(context);
      },
    );

    return Column(
      children: [
        _buildForm(),
        ref.watch(updateShopControllerProvider).when(data: (data) {
          return _buildSaveButton(
              child: Text(
                'SAVE',
                style: MyTextStyle.button1,
              ),
              onPressed: () => updateShop());
        }, error: (_, __) {
          return _buildSaveButton(
              child: Text(
                'SAVE',
                style: MyTextStyle.button1,
              ),
              onPressed: () => updateShop());
        }, loading: () {
          return _buildSaveButton(child: CupertinoActivityIndicator());
        }),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
              label: 'Shop name',
              textEditingController: shopNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter shop name';
                }
                return null;
              },
              maxLength: 50),
          Row(
            children: [
              _buildFormFieldLabel(label: 'Address'),
              IconButton(
                onPressed: () async {},
                icon: Icon(Icons.my_location_rounded),
              ),
            ],
          ),
          _buildFormField(
              label: 'House no./Flat no.',
              textEditingController: shopNoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter plot no.';
                }
                return null;
              },
              maxLength: 4),
          _buildFormField(
              label: 'Street/town',
              textEditingController: streetController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter street name';
                }
                return null;
              },
              maxLength: 50),
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                    label: 'City',
                    textEditingController: cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                    maxLength: 50),
              ),
              Expanded(
                child: _buildFormField(
                  label: 'Pin Code',
                  textEditingController: pinCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pin code';
                    }
                    return null;
                  },
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _buildFormField(
              label: 'Location',
              readOnly: true,
              maxLines: 1,
              textEditingController: latlngController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose your location';
                }
                return null;
              },
              suffixIcon: InkWell(
                child: Icon(Icons.my_location_rounded),
                onTap: () async {
                  PickedData pickedData = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LocationPicker(),
                  ));
                  setState(() {
                    latlngController.text = pickedData.latLong.latitude.toString() +
                        "," +
                        pickedData.latLong.longitude.toString();
                  });
                },
              )),
          _buildFormField(
              label: 'Description',
              textEditingController: shopDescriptionController,
              maxLength: 500,
              maxLines: 7,
              minLines: 3),
          _buildUploadView(
            title: 'Select shop photo',
            file: shopPhoto,
            data: (data) {
              shopPhoto.fileName = data;
            },
            error: (_, __) {
              shopPhoto.fileName = null;
            },
            loading: () => shopPhoto.fileName = null,
          )
        ],
      ),
    );
  }

  void updateShop() {
    if (shopPhoto.fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload shop photo')));
      return;
    }

    ShopEntity shop = ShopEntity(
        shopName: shopNameController.text,
        shopDescription: shopDescriptionController.text,
        shopNo: shopNoController.text,
        street: streetController.text,
        city: cityController.text,
        pincode: pinCodeController.text,
        avatarUrl: shopPhoto.fileName,
        //latlng: shopAddress!.lat.toString() + "," + shopAddress!.long.toString(),
        partnerId: FirebaseAuth.instance.currentUser?.uid,
        landmark: landmarkController.text);

    ref.read(updateShopControllerProvider.notifier).updateShop(shop);
  }

  Widget _buildFormFieldLabel({required String label}) {
    return Text(
      label,
      style: MyTextStyle.formLabel,
    );
  }

  Widget _buildFormField({
    required String label,
    TextEditingController? textEditingController,
    int? maxLength,
    TextInputType? keyboardType,
    FormFieldValidator? validator,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? minLines,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormFieldLabel(label: label),
          TextFormField(
            maxLines: maxLines,
            minLines: minLines,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            validator: validator,
            controller: textEditingController,
            maxLength: maxLength,
            keyboardType: keyboardType,
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
              suffixIcon: suffixIcon,
            ),
            style: MyTextStyle.formTextField,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadView({
    String title = '',
    required AttachedImage file,
    Function(String data)? data,
    Function(Object error, StackTrace stackTrace)? error,
    Function()? loading,
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                child: file.file == null
                    ? Container(
                        margin: EdgeInsets.all(
                          20.0,
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: MyTextStyle.text4,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Icon(
                              Icons.image_outlined,
                              color: AppColors.pureblack,
                              size: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildCameraButton(
                                  onTap: () async {
                                    XFile? xFile =
                                        await ImagePicker().pickImage(source: ImageSource.camera);
                                    if (xFile != null) {
                                      setState(() => file.file = xFile);
                                    }
                                  },
                                ),
                                _buildBrowseButton(
                                  onTap: () async {
                                    XFile? xFile =
                                        await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (xFile != null) {
                                      setState(() => file.file = xFile);
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : _buildImage(file.file!, onClose: () {
                        setState(() => file.file = null);
                      }, onData: data, onError: error, onLoading: loading),
              )),
        );
      },
    );
  }

  Widget _buildImage(
    XFile file, {
    GestureTapCallback? onClose,
    Function(String data)? onData,
    Function(Object error, StackTrace stackTrace)? onError,
    Function()? onLoading,
  }) {
    return Container(
      child: Stack(
        children: [
          Container(
              color: Colors.deepPurple, child: Image.file(File(file.path), fit: BoxFit.cover)),
          Positioned(
            top: 0,
            left: 0,
            child: ref.watch(imageUploadControllerProvider(file)).when(
              data: (data) {
                if (onData != null) {
                  onData(data ?? '');
                }
                return Container();
              },
              error: (error, stackTrace) {
                if (onError != null) {
                  onError(error, stackTrace);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Icon(Icons.error),
                    onTap: () => ref.refresh(imageUploadControllerProvider(file)),
                  ),
                );
              },
              loading: () {
                if (onLoading != null) {
                  onLoading();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: onClose,
                child: Icon(
                  Icons.cancel_rounded,
                  color: AppColors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBrowseButton({GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: AppColors.yellow,
        ),
        child: Text(
          "Browse",
          style: MyTextStyle.button1,
        ),
      ),
    );
  }

  Widget _buildCameraButton({GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: AppColors.yellow,
        ),
        child: Text(
          "Camera",
          style: MyTextStyle.button1,
        ),
      ),
    );
  }

  Widget _buildSaveButton({required Widget child, final VoidCallback? onPressed}) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onPressed,
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
          color: AppColors.yellow,
        ),
        child: child,
      ),
    );
  }
}
