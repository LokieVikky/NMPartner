import 'package:partner/Screens/ProfilePages/addNewEmployee.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeCard extends StatelessWidget {
  String employeeName;
  String profile;
  String id;

  EmployeeCard({this.employeeName, this.profile, this.id});

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Material(
        elevation: 20.0,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Container(
          // margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 40.0,
                  backgroundImage: NetworkImage(profile),
                ),
              ),
              Expanded(
                child: Text(
                  employeeName,
                  overflow: TextOverflow.fade,
                  style: MyTextStyle.text1,
                ),
              ),
              Container(
                height: _height / 10,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddNewEmployee(
                              data: {
                                'name': employeeName,
                                'id': id,
                                'profile': profile
                              },
                            ),
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.mode_edit,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                      onPressed: () => employeeProvider.removeEmployee(id),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
