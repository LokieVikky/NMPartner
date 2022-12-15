import 'package:partner/Screens/ProfilePages/addNewEmployee.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/Screens/ProfilePages/widgets/employeeCard.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class EditEmployee extends StatelessWidget {
  final employee;

  const EditEmployee({Key? key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.pureblack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee details",
                style: MyTextStyle.text1,
              ),
            ),
            Column(
              children: [
                EmployeeCard(
                  employeeName: 'name',
                  profile: 'profile',
                  id: "key",
                ),
              ],
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddNewEmployee(),
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: 30.0,
                  left: 20.0,
                  right: 20.0,
                ),
                height: _height / 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.purple2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Add new employee",
                    style: MyTextStyle.text15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
