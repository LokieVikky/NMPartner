import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/Screens/OrderPages/vehicle_info.dart';
import 'package:partner/Screens/OrderPages/widgets/order_button.dart';
import 'package:partner/Screens/OrderPages/widgets/problem_details.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/provider/orderProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirm extends StatelessWidget {
  final data;

  const OrderConfirm({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedEmployee = 0;
    final _profilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    final _orderProvider = Provider.of<orderProvider>(context, listen: false);
    _profilePageProvider.getEmployee();
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
    var time = '${timeParser.hour}:${timeParser.minute}';
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
            bottom: 50.0,
            top: 10.0,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Text(
                  "${date}  ${time}",
                  style: MyTextStyle.text4,
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
                child: Column(
                  children: [
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
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/profile.png'),
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
                        bottom: 10.0,
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
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      child: ProblemDetails(
                        data: data,
                      ),
                    ),
                    Consumer<ProfilePageProvider>(
                      builder: (context, instance, V) => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _profilePageProvider.employee.length,
                        itemBuilder: (context, index) {
                          String key = _profilePageProvider.employee.keys
                              .elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              selectedEmployee = _profilePageProvider
                                  .selectEmployee(index, selectedEmployee);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              padding: EdgeInsets.only(
                                left: 20.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: selectedEmployee != null &&
                                        selectedEmployee == index
                                    ? MyColors.lightgreen
                                    : MyColors.grey1,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _profilePageProvider
                                                    .employee[key]['profile']),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            _profilePageProvider.employee[key]
                                                ['name'],
                                            style: MyTextStyle.text10,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  selectedEmployee != null &&
                                          selectedEmployee == index
                                      ? Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.check,
                                            color: MyColors.darkgreen,
                                            size: 45,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () => {
                            data['stage'] = 4,
                            _orderProvider
                                .cancelOrder(data)
                                .then((d) => Navigator.of(context).pop())
                          },
                          child: OrderButton(
                            button_name: "Cancel order",
                            button_color: MyColors.purewhite,
                            text_color: MyColors.red,
                            border_color: MyColors.red,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            String key = _profilePageProvider.employee.keys
                                .elementAt(selectedEmployee);
                            data['stage'] = 2;
                            data['empName'] =
                                _profilePageProvider.employee[key]['name'];
                            data['empUrl'] =
                                _profilePageProvider.employee[key]['profile'];
                            data['empUID'] =
                                _profilePageProvider.employee[key]['id'];
                            _orderProvider
                                .updateOrder(
                                  data['id'],
                                  2,
                                  _profilePageProvider.employee[key]['name'],
                                  _profilePageProvider.employee[key]['id'],
                                  _profilePageProvider.employee[key]['profile'],
                                )
                                .then((d) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderPage(data: data),
                                    )));
                          },
                          child: OrderButton(
                            button_name: "Confirm order",
                            button_color: MyColors.purple,
                            text_color: MyColors.purewhite,
                            border_color: MyColors.purple,
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
