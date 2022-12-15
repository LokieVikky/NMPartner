import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  String button_name;
  Color border_color, button_color, text_color;
  OrderButton({
    required this.button_name,
    required this.border_color,
    required this.button_color,
    required this.text_color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: button_color,
        border: Border.all(
          color: border_color,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Text(
        button_name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: text_color,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
