import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/Screens/HomePages/widgets/vehicle_info_home.dart';
import 'package:partner/Screens/OrderPages/orderConfirm.dart';
import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class OnGoingOrderCard extends ConsumerStatefulWidget {
  OrderListEntity? entity;

  // TYPE 0 - pending Orders | 1 - actionRequired Orders
  int? screenType;

  OnGoingOrderCard({Key? key, this.entity, this.screenType}) : super(key: key);

  @override
  _OnGoingOrderCardState createState() => _OnGoingOrderCardState();
}

class _OnGoingOrderCardState extends ConsumerState<OnGoingOrderCard> {
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
            margin: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: Row(
              children: [
                Text(
                  "OrderID - ",
                  style: MyTextStyle.text12,
                ),
                Text(
                  widget.entity!.orderId!.substring(0, 13),
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
                  vehicle: "Amount:",
                  value: widget.entity!.amount!,
                ),
                VehicleInfoHome(
                  vehicle: "Placed on:",
                  value: widget.entity!.placedOn!.substring(0, 10),
                ),
                widget.screenType == 1
                    ? VehicleInfoHome(
                        vehicle: "Status:",
                        value: widget.entity!.orderStatus!,
                      )
                    : SizedBox(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if (widget.screenType == 0) {
                  return OrderConfirm(data: widget.entity);
                } else {
                  return OrderPage(data: widget.entity);
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
  }
}
