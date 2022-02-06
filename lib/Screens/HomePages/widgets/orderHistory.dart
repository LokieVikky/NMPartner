import 'package:partner/provider/currentState.dart';
import 'package:partner/provider/orderProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ongoingOrders.dart';

class orderHistory extends StatefulWidget {
  @override
  _orderHistoryState createState() => _orderHistoryState();
}

class _orderHistoryState extends State<orderHistory> {
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<orderProvider>(context, listen: false);
    final currentProvider = Provider.of<CurrentState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    if (ordersProvider.data != null) {
      setState(() {
        isEmpty = false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 40.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Customers Orders",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.purple,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            StreamBuilder(
                stream: ordersProvider.orderHistory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Consumer<orderProvider>(
                    builder: (context, instance, V) {
                      return ListView.builder(
                          itemCount: instance.dataHistory.length == 0
                              ? 0
                              : instance.dataHistory.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            return OnGoingOrderCard(
                              data: instance.dataHistory[index],
                            );
                          });
                    },
                  );
                }),
            Visibility(
              visible: !isEmpty,
              child: Container(
                width: size.width,
                child: Column(
                  children: [
                    Image.asset('assets/images/orderHistory.png'),
                    Text(
                      'No Order History',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
