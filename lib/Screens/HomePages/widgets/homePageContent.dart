import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/state/orderListState.dart';
import 'package:partner/values/MyColors.dart';

import '../../../provider/mProvider/ordersProvider.dart';
import 'ongoingOrders.dart';

class HomePageContent extends ConsumerStatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends ConsumerState<HomePageContent> {
  bool isEmpty = true;
  Map<int, int> mMap = {};

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // executes after build
      ref.read(placedOrderListNotifierProvider.notifier).getOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Pending Orders",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.purple,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                OrderListState state =
                    ref.watch(placedOrderListNotifierProvider);
                return () {
                  return state.entity!.when(data: (mList) {
                    return mList.isNotEmpty
                        ? SingleChildScrollView(
                          child: ListView.builder(
                              itemCount: mList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {
                                return OnGoingOrderCard(
                                  entity: mList[index],
                                  screenType: 0,
                                );
                              }),
                        )
                        : Container(
                          width: size.width,
                          child: Column(
                            children: [
                              Image.asset('assets/images/noOrder.png'),
                              Text(
                                'No Pending Orders',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        );
                  }, error: (error, errTxt) {
                    return Center(child: Text(errTxt.toString()));
                  }, loading: () {
                    return Center(child: CircularProgressIndicator());
                  });
                }();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
