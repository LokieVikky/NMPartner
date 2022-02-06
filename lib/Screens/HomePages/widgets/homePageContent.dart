import 'package:partner/provider/orderProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ongoingOrders.dart';

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ordersProvider = Provider.of<orderProvider>(context, listen: true);
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
        child: Stack(
          children: [
            Column(
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
                    "On Progress",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: MyColors.purple,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: ordersProvider.getOrder(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Consumer<orderProvider>(
                        builder: (context, instance, V) {
                          return ListView.builder(
                              itemCount: instance.data == null
                                  ? 0
                                  : instance.data.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {
                                return OnGoingOrderCard(
                                  data: instance.data[index],
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
                        Image.asset('assets/images/noOrder.png'),
                        Text('No Pending Orders',style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
