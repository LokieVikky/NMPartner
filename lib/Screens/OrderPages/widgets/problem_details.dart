import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class ProblemDetails extends StatelessWidget {
  double Box_Radius = 15.0;
  final data;
  double chargePrice = 0;

  ProblemDetails({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    Map charges = data['charges'];
    print(charges);
    data['services'].forEach((e) => chargePrice += e['price']);
    charges.values.forEach((element) => chargePrice += element);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        color: MyColors.yellow1,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(
              20.0,
            ),
            height: _height / 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              borderRadius: BorderRadius.all(
                Radius.circular(Box_Radius),
              ),
              border: Border.all(
                color: MyColors.yellow,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Mechanic verify\nOTP number",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: MyColors.purple,
                      fontFamily: 'Poppins',
                      height: 1.2),
                ),
                Text(
                  data['otp'].toString().split('').join('-'),
                  style: MyTextStyle.text1,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 25.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Describe the problem",
              style: MyTextStyle.text5,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20, top: 6, bottom: 20),
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 10.0,
              bottom: 10.0,
            ),
            height: _height / 5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              borderRadius: BorderRadius.all(
                Radius.circular(Box_Radius),
              ),
              border: Border.all(
                color: MyColors.yellow,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Text(
                data['description'],
                maxLines: 12,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  height: 1.4,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: MyColors.purple,
                  fontFamily: 'Poppins',
                )),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Repairement & \nServices",
                        style: MyTextStyle.text5,
                      ),
                      Text(
                        "Price Rate",
                        style: MyTextStyle.text5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 5.0,
            ),
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              border: Border.all(
                color: MyColors.yellow,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(Box_Radius),
              ),
            ),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data['services'].length,
                itemBuilder: (context, index) {
                  var abc = data['services'][index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  width: 2,
                                  color: MyColors.grey,
                                ),
                              ),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: MyColors.purple,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              abc['name'],
                              overflow: TextOverflow.fade,
                              style: MyTextStyle.text4,
                            ),
                          ],
                        ),
                        Text(
                          '₹${abc['price'].toString()}',
                          overflow: TextOverflow.fade,
                          style: MyTextStyle.text9,
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              "Other charges",
              style: MyTextStyle.text5,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 50.0,
              right: 50.0,
              top: 10.0,
              bottom: 10.0,
            ),
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.purewhite,
              border: Border.all(
                color: MyColors.yellow,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(Box_Radius),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: charges.length,
                  itemBuilder: (context, index) {
                    String key = charges.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            key,
                            style: MyTextStyle.text4,
                          ),
                          Text(
                            '₹${charges[key].toString()}',
                            style: MyTextStyle.text4,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 2,
                  width: double.infinity,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total payment",
                        style: MyTextStyle.text4,
                      ),
                      Text(
                        "₹${chargePrice}",
                        style: MyTextStyle.text4,
                      ),
                    ],
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
