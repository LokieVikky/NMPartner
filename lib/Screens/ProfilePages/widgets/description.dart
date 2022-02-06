import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfilePageProvider>(context, listen: true);
    if (profileProvider.profileData != null) {
      return Container(
        margin: EdgeInsets.only(
          top: 20,
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: MyTextStyle.shopHeading1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              profileProvider.profileData['description'],
              maxLines: 20,
              textAlign: TextAlign.justify,
              style: MyTextStyle.shopText2,
            )
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Description",
              style: MyTextStyle.shopHeading1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "",
            maxLines: 20,
            textAlign: TextAlign.justify,
            style: MyTextStyle.shopText2,
          )
        ],
      ),
    );
  }
}
