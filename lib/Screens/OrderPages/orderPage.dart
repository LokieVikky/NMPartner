import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/Screens/OrderPages/vehicle_info.dart';
import 'package:partner/Screens/OrderPages/widgets/orderStatusDropDown.dart';
import 'package:partner/Screens/OrderPages/widgets/problem_details.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/provider/mProvider/customerInfoProvider.dart';
import 'package:partner/provider/mProvider/ordersProvider.dart';
import 'package:partner/services/apiService.dart';
import 'package:partner/state/customerState.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/mProvider/commanProviders.dart';

class OrderPage extends ConsumerStatefulWidget {
  WorkOrder? data;

  OrderPage({Key? key, this.data}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref
          .read(pendingOrderInfoNotifierProvider.notifier)
          .getPendingOrders(widget.data!.consumerId!, widget.data!.orderId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purewhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.pureblack,
          ),
          onPressed: () => Navigator.popAndPushNamed(context, '/homePage'),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Consumer(builder: (context, ref, child) {
          PendingOrderState state = ref.watch(pendingOrderInfoNotifierProvider);
          return () {
            return state.data!.when(
                data: (data) => SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "OrderID : ",
                                      style: MyTextStyle.text3,
                                    ),
                                    Text(
                                      widget.data!.orderId!.substring(0, 13),
                                      style: MyTextStyle.text1,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Date : ",
                                      style: MyTextStyle.text3,
                                    ),
                                    Text(
                                      widget.data!.placedOn!.substring(0, 10),
                                      style: MyTextStyle.text1,
                                    ),
                                  ],
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                  color: AppColors.yellow),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: AppColors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff545672),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                    data.custProfile!),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Customer name",
                                            style: MyTextStyle.text6,
                                          ),
                                          Text(
                                            data.custName!,
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
                                        vehicle: "Phone:",
                                        value: "",
                                      ),
                                      VehicleInfo(
                                        vehicle: "Amount:",
                                        value: '₹ ' + widget.data!.amount!,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    ProblemDetails(
                                      data: widget.data,
                                      serviceList: data.serviceModel,
                                    ),
                                    OrderStatusDropDown(widget.data),
                                    GestureDetector(
                                      onTap: () async {
                                        String orderStatus =
                                            ref.watch(orderStatusDropdownItem);
                                        bool result = await ref
                                            .read(
                                                changeOrderStatusNotifierProvider
                                                    .notifier)
                                            .changeStatus(widget.data!.orderId!,
                                                orderStatus);
                                        if (result) {
                                          showSnack('update success');
                                        } else {
                                          showSnack('update failed');
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 20.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        height: size.height / 12,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.purple2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Update Order Status",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.purewhite,
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
                error: (error, txt) => Text(txt.toString()),
                loading: () => Center(child: CircularProgressIndicator()));
          }();
        }),
      ),
    );
  }

  void showSnack(String msg) {
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
