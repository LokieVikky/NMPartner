import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';

class Details extends StatefulWidget {
  PartnerInfoEntity partnerEntity;
  ShopEntity shopEntity;

  Details(this.partnerEntity, this.shopEntity);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

      return Container(
        height: _height / 4,
        width: width / 1,
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            color: AppColors.yellow2,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.pureblack),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(widget.partnerEntity.partnerProfilePic!,
                     fit: BoxFit.fitWidth),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width / 2 + 20,
                  child: AutoSizeText(
                    widget.partnerEntity.partnerName!,
                    style: MyTextStyle.shopHeading1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: AutoSizeText(
                    widget.shopEntity.shopName!,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: MyTextStyle.shopText1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            )
          ],
        ),
      );
  }
}
