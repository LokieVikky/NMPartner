import 'package:flutter/material.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class Header extends StatelessWidget {
  String text, button_text;
  final path;
  Color bgColor, textColor;
  bool? buttonVisibility = true;

  Header(
      {required this.text,
      this.path,
      required this.button_text,
      required this.bgColor,
      required this.textColor,
      this.buttonVisibility});

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
          buttonVisibility!
              ? GestureDetector(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => path)),
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
                )
              : Container(),
        ],
      ),
    );
  }
}
