import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/Screens/OrderPages/vehicle_info.dart';
import 'package:partner/Screens/OrderPages/widgets/order_button.dart';
import 'package:partner/Screens/OrderPages/widgets/problem_details.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/provider/mProvider/ordersProvider.dart';
import 'package:partner/provider/orderProvider.dart';
import 'package:partner/state/customerState.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

import '../../entity/orderListEntity.dart';
import '../../provider/mProvider/customerInfoProvider.dart';

class OrderConfirm extends ConsumerStatefulWidget {
  OrderListEntity? data;

  OrderConfirm({Key? key, this.data}) : super(key: key);

  @override
  _OrderConfirmState createState() => _OrderConfirmState();
}

class _OrderConfirmState extends ConsumerState<OrderConfirm> {

  @override
  void initState() {
    ref.read(pendingOrderInfoNotifierProvider.notifier).getPendingOrders(
        widget.data!.customerId!, widget.data!.orderId!);
  }

  @override
  Widget build(BuildContext context) {
    var selectedEmployee = 0;
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
      body: Container(
        margin: EdgeInsets.only(
          bottom: 50.0,
          top: 10.0,
        ),
        child: Consumer(
            builder: (context, ref, child) {
              PendingOrderState? mData = ref.watch(
                  pendingOrderInfoNotifierProvider);
              return () {
                return mData!.data!.when(data: (custData) =>
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              bottom: 20.0,
                            ),
                            child: Text('Order ID - ' +
                                widget.data!.orderId!.substring(0, 13),
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
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 115,
                                            width: 115,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: MyColors.yellow),
                                              borderRadius: BorderRadius.circular(
                                                  100),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: MyColors.yellow,
                                              borderRadius: BorderRadius.circular(
                                                  100),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: Image.network(
                                                  custData.custProfile!),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "Customer name",
                                            style: MyTextStyle.text6,
                                          ),
                                          Text(
                                            custData.custName!,
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
                                        vehicle: "Phone",
                                        value: '' //todo should add
                                      ),
                                      VehicleInfo(
                                        vehicle: "Amount",
                                        value: widget.data!.amount!,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                  ),
                                  child: ProblemDetails(
                                    data: widget.data,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    FlatButton(
                                      onPressed: () async {
                                       bool result = await ref.read(changeOrderStatusNotifierProvider.notifier)
                                            .changeStatus(widget.data!.orderId!, 'REJECTED');
                                       if(result) {
                                        showSnack('update success');
                                       } else {
                                         showSnack('update failed');
                                       }
                                      },
                                      child: OrderButton(
                                        button_name: "Cancel order",
                                        button_color: MyColors.purewhite,
                                        text_color: MyColors.red,
                                        border_color: MyColors.red,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        bool result = await ref.read(changeOrderStatusNotifierProvider.notifier)
                                            .changeStatus(widget.data!.orderId!, 'ACCEPTED');
                                        if(result) {
                                          showSnack('update success');
                                        } else {
                                          showSnack('update failed');
                                        }
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
                    error: (error, eTxt) =>
                        Center(child: Text(eTxt.toString()),),
                    loading: () => Center(child: CircularProgressIndicator()));
              }();
            }
        ),
      ),
    );

  }
  void showSnack (String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 15.0);
    Navigator.pop(context);
  }
}



