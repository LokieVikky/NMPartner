import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class AsignedMechanic extends StatelessWidget {
  final data;

  const AsignedMechanic({Key? key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              // color: MyColors.yellow,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage('empUrl'),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'empName',
                style: MyTextStyle.text7,
              ),
              SizedBox(
                height: 10.0,
              ),

            ],
          ),
        ],
      ),
    );
  }
}
