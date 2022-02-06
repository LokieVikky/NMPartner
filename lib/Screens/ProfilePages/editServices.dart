import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/Screens/ProfilePages/widgets/newService.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditServices extends StatelessWidget {
  final services;

  const EditServices({Key key, this.services}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ProfilePageProvider>(context, listen: false);
    serviceProvider.getServices();
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.pureblack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: MyColors.purewhite,
        elevation: 5,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Services",
                  style: MyTextStyle.text1,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repairement & \n Services',
                        style: MyTextStyle.shopHeading1,
                      ),
                      Text(
                        'Price rate',
                        style: MyTextStyle.shopHeading1,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  padding: EdgeInsets.all(
                    10.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    border: Border.all(
                      color: MyColors.yellow,
                    ),
                    color: MyColors.purewhite,
                  ),
                  child: Consumer<ProfilePageProvider>(
                    builder: (context, instance, V) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: serviceProvider.services.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                serviceProvider.services[index]['name'],
                                style: MyTextStyle.text4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹ ' +
                                        serviceProvider.services[index]['price']
                                            .toString(),
                                    style: MyTextStyle.text4,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  GestureDetector(
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: AddNewService(
                                            data: {
                                              'name': serviceProvider
                                                  .services[index]['name'],
                                              'price': serviceProvider
                                                  .services[index]['price'],
                                              'index': index
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.edit_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddNewService(),
                      ),
                    ),
                  ),
                  child: Container(
                    height: _height / 15,
                    width: _width,
                    margin: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(
                        color: MyColors.purple,
                      ),
                      color: MyColors.purple,
                    ),
                    child: Center(
                      child: Text("Add new service",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: MyColors.purewhite,
                            fontFamily: 'Poppins',
                          )),
                    ),
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
