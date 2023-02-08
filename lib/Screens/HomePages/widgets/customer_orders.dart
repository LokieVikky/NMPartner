import 'package:partner/Screens/HomePages/widgets/customer_order_cards.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';

class CustomerOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purewhite,
        elevation: 0,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: AppColors.pureblack,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Customer orders",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.purple,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            CustomerOrderCards(),
            CustomerOrderCards(),
            CustomerOrderCards(),
          ],
        ),
      ),
    );
  }
}
