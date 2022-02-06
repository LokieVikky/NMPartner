import 'package:partner/Screens/HomePages/widgets/vehicle_info_home.dart';
import 'package:partner/Screens/OrderPages/orderConfirm.dart';
import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class OnGoingOrderCard extends StatelessWidget {
  final Map data;

  const OnGoingOrderCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mL = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    var mS = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];

    var date = '';
    if (data != null) {
      Timestamp dateTime = data['time'];
      var timeParser = new DateTime.fromMicrosecondsSinceEpoch(
          dateTime.microsecondsSinceEpoch);
      date = '${timeParser.day} ${mS[timeParser.month-1]}, ${timeParser.year}';
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
              margin: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "OrderID - ${data['orderId']}",
                      style: MyTextStyle.text12,
                    ),
                  ),
                  Text(
                    date,
                    style: MyTextStyle.text13,
                  ),
                ],
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
                lineThickness: 1.5,
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
                top: 20,
                bottom: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VehicleInfoHome(
                    vehicle: "Vehicle Type:",
                    value: data['vehicleType'],
                  ),
                  VehicleInfoHome(
                    vehicle: "Vehicle Name:",
                    value: data['vehicleName'],
                  ),
                  VehicleInfoHome(
                    vehicle: "Vehicle Number:",
                    value: data['vehicleBrand'],
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  if (data['stage'] == 1) {
                    return OrderConfirm(data: data);
                  } else {
                    return OrderPage(data: data);
                  }
                },
              )),
              child: Container(
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
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
