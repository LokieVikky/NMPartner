import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  String profileImg;

  Details({this.profileImg});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final detailProvider =
        Provider.of<ProfilePageProvider>(context, listen: true);
    if (detailProvider.profileData != null) {
      var data = detailProvider.profileData;
      return Container(
        height: _height / 4,
        width: width / 1,
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            color: MyColors.yellow2,
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
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: MyColors.parrotGreen),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    //color: MyColors.blue_ribbon,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: data['shopImages']['profile'] == null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                              )
                            : NetworkImage(
                                data['shopImages']['profile'],
                              ),
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width / 2 + 20,
                  child: AutoSizeText(
                    data['shopName'],
                    style: MyTextStyle.shopHeading1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: AutoSizeText(
                    "${data['address']['street']},${data['address']['city']}",
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
    return Container(
      height: _height / 4,
      width: width / 1,
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
          color: MyColors.yellow2,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )),
    );
  }
}
