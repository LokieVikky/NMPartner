import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String button_text;
  Color bgColor, textColor;

  CustomButton({
    this.button_text,
    this.bgColor,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
        height: _height / 15,
        width: _width / 3.5,
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
    );
  }
}
