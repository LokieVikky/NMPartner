import 'package:partner/Screens/ProfilePages/editProfilePage.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  String text, button_text;
  final path;
  Color bgColor, textColor;

  Header({
    this.text,
    this.path,
    this.button_text,
    this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: MyTextStyle.text1,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => path)),
            child: Container(
              height: _height / 15,
              width: _width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                border: Border.all(
                  color: MyColors.purple,
                ),
                color: bgColor,
              ),
              child: Center(
                child: Text(button_text,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                      fontFamily: 'Poppins',
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
