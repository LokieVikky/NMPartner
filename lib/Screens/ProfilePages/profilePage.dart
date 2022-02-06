import 'package:partner/Screens/ProfilePages/editEmployee.dart';
import 'package:partner/Screens/ProfilePages/editProfilePage.dart';
import 'package:partner/Screens/ProfilePages/editServices.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/Screens/ProfilePages/widgets/ImageCarousel.dart';
import 'package:partner/Screens/ProfilePages/widgets/balance.dart';
import 'package:partner/Screens/ProfilePages/widgets/description.dart';
import 'package:partner/Screens/ProfilePages/widgets/details.dart';
import 'package:partner/Screens/ProfilePages/widgets/employeeCarousel.dart';
import 'package:partner/Screens/ProfilePages/widgets/header.dart';
import 'package:partner/Screens/ProfilePages/widgets/services.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ProfilePageProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    _ProfilePageProvider.getProfile();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              text: "Profile",
              button_text: "Edit",
              bgColor: MyColors.purple,
              textColor: MyColors.purewhite,
              path: EditProfilePage(),
            ),
            Container(
              color: MyColors.lightYellow,
              width: double.infinity,
              child: Column(
                children: [
                  Details(),
                  ImageCarousel(),
                  Description(),
                ],
              ),
            ),
            Header(
              text: "Your Services",
              button_text: "Edit",
              bgColor: MyColors.purple,
              textColor: MyColors.purewhite,
              path: EditServices(
                services: _ProfilePageProvider.services,
              ),
            ),
            Container(
              color: MyColors.lightYellow,
              width: double.infinity,
              child: Services(),
            ),
            Header(
              text: "Employee Details",
              button_text: "Edit",
              bgColor: MyColors.purple,
              textColor: MyColors.purewhite,
              path: EditEmployee(
                employee: _ProfilePageProvider.employee,
              ),
            ),
            EmployeeCarousel(),
          ],
        ),
      ),
    );
  }
}
