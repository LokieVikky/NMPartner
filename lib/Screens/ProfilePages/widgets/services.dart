import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/models/mModel/nm_service.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  List<NMService> services = [];
  Services(this.services, {Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.yellow,
              ),
              color: AppColors.purewhite,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: widget.services.length,
                      itemBuilder: (context, index) => getShopServiceItem(widget.services[index])),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getShopServiceItem(NMService service) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          service.name??'',
          style: MyTextStyle.text4,
        ),
        Text(
          '₹ ' + service.rate.toString(),
          style: MyTextStyle.text4,
        ),
      ],
    );
  }

}
