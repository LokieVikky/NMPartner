import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    employeeProvider.getEmployee();
    return Container(
      height: 150,
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Consumer<ProfilePageProvider>(
        builder: (context, instance, V) => ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: employeeProvider.employee.length,
          itemBuilder: (context, index) {
            String key = employeeProvider.employee.keys.elementAt(index);
            return Container(
              padding: EdgeInsets.all(
                10.0,
              ),
              margin: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 20.0,
              ),
              decoration: BoxDecoration(
                color: MyColors.lightYellow,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage:
                        NetworkImage(employeeProvider.employee[key]['profile']),
                  ),
                  Text(
                    employeeProvider.employee[key]['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: MyColors.purple,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
