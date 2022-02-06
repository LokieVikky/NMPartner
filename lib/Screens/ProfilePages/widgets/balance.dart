import 'package:partner/Screens/ProfilePages/widgets/customButton.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Balance Rs. 500",
                    style: MyTextStyle.text5,
                  ),
                  Text(
                    "( Add money to your wallet )",
                    style: MyTextStyle.text4,
                  ),
                ],
              ),
              CustomButton(
                button_text: "Add money",
                bgColor: MyColors.purple,
                textColor: MyColors.purewhite,
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "All Transactions",
                    style: MyTextStyle.text5,
                  ),
                  Text(
                    "( View all transactions )",
                    style: MyTextStyle.text4,
                  ),
                ],
              ),
              CustomButton(
                button_text: "Transactions",
                bgColor: Colors.transparent,
                textColor: MyColors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
