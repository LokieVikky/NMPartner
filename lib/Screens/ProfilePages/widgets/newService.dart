import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddNewService extends StatefulWidget {
  final data;

  const AddNewService({Key key, this.data}) : super(key: key);

  @override
  _AddNewServiceState createState() => _AddNewServiceState();
}

class _AddNewServiceState extends State<AddNewService> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      _name.text = widget.data['name'];
      _price.text = widget.data['price'].toString();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final serviceProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(30.0),
      width: double.infinity,
      color: Colors.white,
      child: Form(
        key: _key,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter service name',
                style: MyTextStyle.text4,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: TextField(
                controller: _name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.yellow),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                // top: 20.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter the price',
                style: MyTextStyle.text4,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: TextField(
                controller: _price,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColors.yellow,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20.0,
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
                    width: _width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(
                        color: MyColors.purple,
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
                  width: _width / 12,
                ),
                FlatButton(
                  onPressed: () {
                    if (widget.data != null) {
                      serviceProvider.updateService(
                          _name.value.text,
                          double.parse(_price.value.text),
                          widget.data['index']);
                      Fluttertoast.showToast(
                              msg: "service updated",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: MyColors.yellow,
                              textColor: Colors.black,
                              fontSize: 20.0)
                          .toString();
                    } else {
                      if (_name.value.text.isNotEmpty &&
                          _price.value.text.isNotEmpty) {
                        serviceProvider.addService(
                            _name.value.text, double.parse(_price.value.text));
                        _name.clear();
                        _price.clear();
                      } else if (_name.value.text.isEmpty) {
                        Fluttertoast.showToast(
                                msg: "Please enter your service name",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: MyColors.yellow,
                                textColor: Colors.black,
                                fontSize: 20.0)
                            .toString();
                      } else {
                        Fluttertoast.showToast(
                                msg: "Please enter your service price",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: MyColors.yellow,
                                textColor: Colors.black,
                                fontSize: 20.0)
                            .toString();
                      }
                    }
                  },
                  child: Container(
                    height: _height / 15,
                    width: _width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(
                        color: MyColors.purple,
                      ),
                      color: MyColors.purple,
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
      ),
    );
  }
}
