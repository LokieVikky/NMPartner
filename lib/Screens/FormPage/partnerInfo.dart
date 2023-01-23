import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/provider/update_partner_controller.dart';
import 'package:partner/provider/upload_image_controller.dart';
import 'package:partner/shared/async_value_ui.dart';
import '../../entity/partnerInfoEntity.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class AttachedImage {
  XFile? file;
  String? fileName;

  AttachedImage(this.file);
}

class PartnerInfo extends ConsumerStatefulWidget {
  const PartnerInfo({Key? key}) : super(key: key);

  @override
  _PartnerInfoState createState() => _PartnerInfoState();
}

class _PartnerInfoState extends ConsumerState<PartnerInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController shopNoController = TextEditingController();
  final TextEditingController priceRateController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController landMarkController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController otherNameController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();
  List<Asset> images = <Asset>[];
  List carouselImages = [];
  File? profileImageUrl;
  String? profileImageLink;
  List services = [];
  bool loading = false;

  XFile? profileImg;
  XFile? aadharFrontImg;
  XFile? aadharBackImg;
  XFile? panFrontImg;
  XFile? panBackImg;

  late AttachedImage profile;
  late AttachedImage aadharFront;
  late AttachedImage aadharBack;
  late AttachedImage panFront;
  late AttachedImage panBack;

  @override
  void initState() {
    super.initState();
    profile = AttachedImage(profileImg);
    aadharFront = AttachedImage(aadharFrontImg);
    aadharBack = AttachedImage(aadharBackImg);
    panFront = AttachedImage(panFrontImg);
    panBack = AttachedImage(panBackImg);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    contactNumberController.dispose();
    shopNoController.dispose();
    priceRateController.dispose();
    streetController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    otherNameController.dispose();
    services.clear();
    aadhaarController.dispose();
    panCardController.dispose();
    images.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      updatePartnerControllerProvider,
      (_, state) {
        if (state is AsyncData) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
        }
        ref.refresh(registrationStatusProvider);
        state.showSnackBarOnError(context);
      },
    );

    contactNumberController.text = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    return Column(
      children: [
        _buildFormV2(),
        ref.watch(updatePartnerControllerProvider).when(data: (data) {
          return _buildSaveButton(
              child: Text(
                'SAVE',
                style: MyTextStyle.button1,
              ),
              onPressed: () => updatePartner());
        }, error: (_, __) {
          return _buildSaveButton(
              child: Text(
                'SAVE',
                style: MyTextStyle.button1,
              ),
              onPressed: () => updatePartner());
        }, loading: () {
          return _buildSaveButton(child: CupertinoActivityIndicator());
        }),
      ],
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
          color: MyColors.yellow,
        ),
        child: child,
      ),
    );
  }

  void updatePartner() {
    if (aadharFront.fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload aadhar front image')));
      return;
    }
    if (aadharBack.fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload aadhar back image')));
      return;
    }
    if (panFront.fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload pan front image')));
      return;
    }
    if (panBack.fileName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload pan back image')));
      return;
    }

    PartnerInfoEntity partnerInfoEntity = PartnerInfoEntity(
        partnerName: fullNameController.text,
        partnerFlatNo: shopNoController.text,
        partnerStreet: streetController.text,
        partnerCity: cityController.text,
        partnerLatlng: "1.1",
        partnerLandmark: landMarkController.text,
        partnerPincode: pinCodeController.text,
        partnerAadhaarFront: aadharFront.fileName,
        partnerAadhaarBack: aadharBack.fileName,
        partnerAadhaarNo: aadhaarController.text,
        partnerPanFront: panFront.fileName,
        partnerPanBack: panBack.fileName,
        partnerPanNo: panCardController.text,
        partnerID: FirebaseAuth.instance.currentUser?.uid,
        partnerProfilePic: profile.fileName);

    ref.read(updatePartnerControllerProvider.notifier).updatePartner(partnerInfoEntity);
  }

  Widget _buildFormV2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Align(
            child: _buildProfileImage(),
            alignment: Alignment.center,
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
          _buildFormField(
              label: 'Full name',
              textEditingController: fullNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                return null;
              }),
          _buildFormField(
              label: 'Contact Number',
              readOnly: true,
              textEditingController: contactNumberController),
          _buildFormFieldLabel(label: 'Address'),
          _buildFormField(
              label: 'House no./ Flat no.',
              textEditingController: shopNoController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter flat no.';
                }
                return null;
              }),
          _buildFormField(
              label: 'Street/town',
              textEditingController: streetController,
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Street name.';
                }
                return null;
              }),
          Row(
            children: [
              Expanded(
                  child: _buildFormField(
                      label: 'City',
                      textEditingController: cityController,
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      })),
              Expanded(
                child: _buildFormField(
                    label: 'Pin Code',
                    textEditingController: pinCodeController,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter pin code';
                      }
                      return null;
                    }),
              ),
            ],
          ),
          _buildFormField(
              label: 'Landmark',
              textEditingController: landMarkController,
              maxLength: 25,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter landmark';
                }
                return null;
              }),
          _buildFormFieldLabel(label: 'Verification Documents'),
          _buildFormField(
              label: 'Aadhar number',
              textEditingController: aadhaarController,
              maxLength: 12,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter aadhar no';
                }
                if (value.lenght < 12) {
                  return 'Invalid Aadhar number';
                }
                return null;
              }),
          _buildUploadView(
              title: 'Upload your Aadhar front photo',
              file: aadharFront,
              data: (data) {
                aadharFront.fileName = data;
              },
              error: (_, __) {
                aadharFront.fileName = null;
              },
              loading: () => aadharFront.fileName = null),
          _buildUploadView(
              title: 'Upload your Aadhar back photo',
              file: aadharBack,
              data: (data) {
                aadharBack.fileName = data;
              },
              error: (_, __) {
                aadharBack.fileName = null;
              },
              loading: () => aadharBack.fileName = null),
          _buildFormField(
              label: 'PAN Number',
              maxLength: 10,
              textEditingController: panCardController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pan no';
                }
                if (value.lenght < 10) {
                  return 'Invalid pan number';
                }
                return null;
              }),
          _buildUploadView(
              title: 'Upload your PAN front photo',
              file: panFront,
              data: (data) {
                panFront.fileName = data;
              },
              error: (_, __) {
                panFront.fileName = null;
              },
              loading: () => panFront.fileName = null),
          _buildUploadView(
              title: 'Upload your PAN back photo',
              file: panBack,
              data: (data) {
                panBack.fileName = data;
              },
              error: (_, __) {
                panBack.fileName = null;
              },
              loading: () => panBack.fileName = null),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () async {
            profile.file = await pickProfileImage();
            setState(() {});
          },
          child: Container(
            height: 115,
            width: 115,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: MyColors.purple),
              borderRadius: BorderRadius.circular(100),
            ),
            child: profile.file == null
                ? Icon(Icons.account_circle_outlined)
                : ref.watch(imageUploadControllerProvider(profile.file!)).when(data: (data) {
                    profile.fileName = data;
                    return Container(
                      width: 115,
                      height: 115,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(File(profile.file!.path), fit: BoxFit.cover),
                      ),
                    );
                  }, error: (_, __) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Icon(Icons.error),
                        onTap: () => ref.refresh(imageUploadControllerProvider(profile.file!)),
                      ),
                    );
                  }, loading: () {
                    return CupertinoActivityIndicator();
                  }),
          ),
        );
      },
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
                              color: MyColors.pureblack,
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
                  color: MyColors.red,
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
          color: MyColors.yellow,
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
          color: MyColors.yellow,
        ),
        child: Text(
          "Camera",
          style: MyTextStyle.button1,
        ),
      ),
    );
  }


  Future<XFile?> pickProfileImage() async {
    XFile? file;
    return await showDialog<XFile?>(
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
                  onTap: () async {
                    file = await ImagePicker().pickImage(source: ImageSource.camera);
                  },
                  child: CircleAvatar(
                      child: Icon(Icons.camera_alt, color: MyColors.pureblack, size: 30),
                      backgroundColor: MyColors.yellow,
                      radius: 40),
                ),
                GestureDetector(
                  onTap: () async {
                    file = await ImagePicker().pickImage(source: ImageSource.gallery);
                  },
                  child: CircleAvatar(
                      child: Icon(Icons.image, color: MyColors.pureblack, size: 30),
                      backgroundColor: MyColors.yellow,
                      radius: 40),
                ),
              ],
            ),
          );
        }).then((value) => file);
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
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            validator: validator,
            controller: textEditingController,
            maxLength: maxLength,
            keyboardType: keyboardType,
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
        ],
      ),
    );
  }
}
