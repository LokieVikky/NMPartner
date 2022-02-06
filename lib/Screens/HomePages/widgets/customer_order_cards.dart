import 'package:partner/Screens/HomePages/widgets/vehicle_info_home.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CustomerOrderCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
      ),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: MyColors.purple,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              "12 Feb, 2021  13:45 PM",
              style: MyTextStyle.text13,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.2,
              dashLength: 4.0,
              dashColor: MyColors.purewhite,
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 115,
                      width: 115,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: MyColors.yellow),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: MyColors.yellow,
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer name",
                      style: MyTextStyle.text14,
                    ),
                    Text(
                      "Rajesh Kumar Rai",
                      style: MyTextStyle.text12,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Column(
              children: [
                VehicleInfoHome(
                  vehicle: "Vehicle Type:",
                  value: "Car",
                ),
                VehicleInfoHome(
                  vehicle: "Vehicle Name:",
                  value: "KWID",
                ),
                VehicleInfoHome(
                  vehicle: "Vehicle Number:",
                  value: "Renault",
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
            ),
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Center(
              child: Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.pureblack,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
