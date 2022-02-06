import 'package:partner/Screens/OrderPages/vehicle_info.dart';
import 'package:partner/Screens/OrderPages/widgets/asigned_mechanic.dart';
import 'package:partner/Screens/OrderPages/widgets/problem_details.dart';
import 'package:partner/provider/orderProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  final data;

  const OrderPage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<orderProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
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

    Timestamp dateTime = data['time'];
    var timeParser = new DateTime.fromMicrosecondsSinceEpoch(
        dateTime.microsecondsSinceEpoch);
    var date =
        '${timeParser.day} ${mS[timeParser.month - 1]}, ${timeParser.year}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.pureblack,
          ),
          onPressed: () => Navigator.popAndPushNamed(context, '/homePage'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "OrderID - ${data['orderId']}",
                        style: MyTextStyle.text1,
                      ),
                    ),
                    Text(
                      date,
                      style: MyTextStyle.text2,
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
                  lineThickness: 1.2,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 15.0,
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
                                  border: Border.all(
                                      width: 1, color: MyColors.yellow),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: MyColors.yellow,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff545672),

                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer name",
                                style: MyTextStyle.text6,
                              ),
                              Text(
                                data['customerName'],
                                style: MyTextStyle.text1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 15.0,
                      ),
                      child: Column(
                        children: [
                          VehicleInfo(
                            vehicle: "Vehicle Type:",
                            value: data['vehicleType'],
                          ),
                          VehicleInfo(
                            vehicle: "Vehicle Name:",
                            value: data['vehicleName'],
                          ),
                          VehicleInfo(
                            vehicle: "Vehicle Number:",
                            value: data['vehicleBrand'],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        AsignedMechanic(
                          data: data,
                        ),
                        ProblemDetails(
                          data: data,
                        ),
                        if (data['stage'] == 2)
                          GestureDetector(
                            onTap: () => {
                              data['stage'] = 3,
                              _orderProvider.orderCompleted(data).then((d) =>
                                  Navigator.popAndPushNamed(
                                      context, '/homePage'))
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20.0,
                                bottom: 30.0,
                                left: 20.0,
                                right: 20.0,
                              ),
                              height: size.height / 12,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColors.purple2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Order Completed",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.purewhite,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
