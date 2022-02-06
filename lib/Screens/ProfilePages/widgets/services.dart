import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Services extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    servicesProvider.getServices();
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              top: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Repairement & \n Services',
                  style: MyTextStyle.shopHeading1,
                ),
                Text(
                  'Price rate',
                  style: MyTextStyle.shopHeading1,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 10.0,
              bottom: 10.0,
            ),
            padding: EdgeInsets.all(
              10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              border: Border.all(
                color: MyColors.yellow,
              ),
              color: MyColors.purewhite,
            ),
            child: Column(
              children: [
                Consumer<ProfilePageProvider>(
                  builder: (context, instance, V) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: servicesProvider.services.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              servicesProvider.services[index]['name'],
                              style: MyTextStyle.text4,
                            ),
                            Text(
                              '₹ ' +
                                  servicesProvider.services[index]['price']
                                      .toString(),
                              style: MyTextStyle.text4,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
