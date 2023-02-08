import 'dart:io';

import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddNewEmployee extends StatefulWidget {
  final data;

  const AddNewEmployee({Key? key, this.data}) : super(key: key);

  @override
  _AddNewEmployeeState createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  File? _image;
  final picker = ImagePicker();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _controller = new TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 25);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.toString());
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      _controller.text = widget.data['name'];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(50.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            onTap: getImage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.purple),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                if (_image == null && widget.data != null) ...{
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.data['profile']),
                  ),
                } else ...{
                  if (_image == null)
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.purewhite,
                          size: 30.0,
                        ),
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(_image!),
                    ),
                },
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter employee fullname',
              style: MyTextStyle.text4,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Form(
              key: _formKey,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.yellow),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: _height / 15,
                  width: _width / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: AppColors.purple,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: MyTextStyle.text4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _width / 10,
              ),
              TextButton(
                onPressed: () {
                  /*
                  if (widget.data != null) {
                    employeeProvider.updateEmployee(
                        oldLink: widget.data['profile'],
                        name: _controller.value.text,
                        profile: _image,
                        uid: widget.data['id']);
                    Navigator.pop(context);
                  } else {
                    if (_image != null) {
                      if (_controller.text.isNotEmpty) {
                        employeeProvider.addEmployee(_controller.text, _image!);
                        _controller.clear();
                      }else{
                        Fluttertoast.showToast(
                            msg:
                            "Please enter Employname",
                            toastLength:
                            Toast.LENGTH_SHORT,
                            gravity:
                            ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                            MyColors.yellow,
                            textColor: Colors.black,
                            fontSize: 20.0)
                            .toString();
                      }
                    }else{
                      Fluttertoast.showToast(
                          msg:
                          "Please Select Employee Image",
                          toastLength:
                          Toast.LENGTH_SHORT,
                          gravity:
                          ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor:
                          MyColors.yellow,
                          textColor: Colors.black,
                          fontSize: 20.0)
                          .toString();
                    }
                  }
*/
                },
                child: Container(
                  height: _height / 15,
                  width: _width / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: AppColors.purple,
                    ),
                    color: AppColors.purple,
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      style: MyTextStyle.text7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
