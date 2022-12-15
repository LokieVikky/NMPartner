import 'package:flutter/cupertino.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';

import '../../../values/MyTextstyle.dart';

class Addresses extends StatefulWidget {
  PartnerInfoEntity partnerEntity;
  ShopEntity shopEntity;

  Addresses(this.partnerEntity, this.shopEntity);

  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: 20,
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shop Address",
              style: MyTextStyle.shopHeading1,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'No: ' +
                      widget.shopEntity.shopNo! +
                      ',\n' +
                      widget.shopEntity.street! +
                      ',\n' +
                      widget.shopEntity.city! +
                      ' - ' +
                      widget.shopEntity.pincode!,
                  maxLines: 20,
                  textAlign: TextAlign.justify,
                  style: MyTextStyle.shopText2,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Your Address",
              style: MyTextStyle.shopHeading1,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'No: ' +
                      widget.partnerEntity.partnerFlatNo! +
                      ',\n' +
                      widget.partnerEntity.partnerStreet! +
                      ',\n' +
                      widget.partnerEntity.partnerCity! +
                      ' - ' +
                      widget.partnerEntity.partnerPincode!,
                  maxLines: 20,
                  textAlign: TextAlign.justify,
                  style: MyTextStyle.shopText2,
                ),
              ],
            ),
          ],
        ));
  }
}
