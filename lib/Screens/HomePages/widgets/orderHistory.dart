import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/provider/mProvider/ordersProvider.dart';
import 'package:partner/state/orderListState.dart';
import 'package:partner/values/MyColors.dart';

import 'ongoingOrders.dart';

class orderHistory extends ConsumerStatefulWidget {
  @override
  _orderHistoryState createState() => _orderHistoryState();
}

class _orderHistoryState extends ConsumerState<orderHistory> {
  bool isEmpty = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref
          .read(getActionRequiredOrdersNotifierProvider.notifier)
          .getActionRequired();
    });
  }

  @override
  Widget build(BuildContext context) {
    /* final ordersProvider = Provider.of<orderProvider>(context, listen: false);
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
    }*/
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 10.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Action Required Orders",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
                color: AppColors.purple,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              OrderListState state =
                  ref.watch(getActionRequiredOrdersNotifierProvider);
              return () {
                return state.entity!.when(
                    data: (data) => SingleChildScrollView(
                          child: data.isNotEmpty
                              ? ListView.builder(
                                  itemCount: data.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, index) {
                                    return OnGoingOrderCard(
                                      entity: data[index],
                                      screenType: 1,
                                    );
                                  })
                              : Visibility(
                                  visible: false,
                                  child: Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/orderHistory.png'),
                                        Text(
                                          'No Order History',
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                    error: (error, erTxt) =>
                        Center(child: Text(erTxt.toString())),
                    loading: () => Center(child: CircularProgressIndicator()));
              }();
            }),
          ),
        ],
      )),
    );
  }
}
