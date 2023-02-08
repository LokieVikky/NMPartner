import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';

class EmployeeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Container(
        padding: EdgeInsets.all(
          10.0,
        ),
        margin: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 20.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightYellow,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40.0,
              /*backgroundImage:
                        NetworkImage(employeeProvider.employee[key]['profile']),*/
            ),
            Text(
              'name',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.purple,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
