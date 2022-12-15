import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/values/MyColors.dart';
import 'package:uuid/uuid.dart';

import '../../../models/mModel/modelService.dart';
import '../../../provider/mProvider/commanProviders.dart';
import '../../../provider/mProvider/selectionProvider.dart';
import '../../../provider/mProvider/serviceProvider.dart';
import '../../../values/MyTextstyle.dart';

class ShopServices extends ConsumerStatefulWidget {
  const ShopServices({Key? key}) : super(key: key);

  @override
  _ShopServicesState createState() => _ShopServicesState();
}

class _ShopServicesState extends ConsumerState<ShopServices> {
  final serviceName = TextEditingController();
  final serviceAmount = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    ref.read(serviceNotifierProvider.notifier).getAllService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Services",
                style: MyTextStyle.formHeading,
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Text(
                "Available Services",
                style: MyTextStyle.formSubHeading,
              ),
            ],
          ),
          Consumer(builder: (context, ref, child) {
            Map<String, ModelService> data = ref.watch(serviceNotifierProvider);
            List<ModelService> selectedList = [];
            data.forEach((key, value) {
              selectedList.add(value);
            });
            return data.isEmpty
                ? Text('No Service Available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (c, index) =>
                        getAvailableServiceItem(selectedList, index));
          }),
          SizedBox(height: 10.0),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Custom Services",
                        style: MyTextStyle.formSubHeading,
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Service Name",
                                style: MyTextStyle.formLabel,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                maxLength: 20,
                                controller: serviceName,
                                keyboardType: TextInputType.name,
                                decoration: new InputDecoration(
                                  counterText: '',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MyColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MyColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                style: MyTextStyle.formTextField,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Amount",
                                style: MyTextStyle.formLabel,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                maxLength: 20,
                                keyboardType: TextInputType.number,
                                controller: serviceAmount,
                                decoration: new InputDecoration(
                                  counterText: '',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MyColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MyColors.yellow,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                style: MyTextStyle.formTextField,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      var uuid = Uuid();
                                      String mId = uuid.v1();
                                      var tempMap = ref
                                          .read(selectedServiceNotifierProvider
                                              .notifier)
                                          .state;
                                      ref.refresh(
                                          selectedServiceNotifierProvider);
                                      tempMap[mId] = ModelService(
                                          serviceName.text.toString(),
                                          serviceAmount.text.toString(),
                                          true,
                                          null,
                                          true,
                                          isCustom: true);
                                      ref
                                          .read(selectedServiceNotifierProvider
                                              .notifier)
                                          .state = tempMap;
                                      serviceName.text = '';
                                      serviceAmount.text = '';
                                    },
                                    child: Text('ADD'))),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                "Selected Services",
                style: MyTextStyle.formSubHeading,
              ),
            ],
          ),
          Consumer(builder: (context, ref, child) {
            Map<String, ModelService> data =
            ref.watch(selectedServiceNotifierProvider);
            List<ModelService> selectedList = [];
            data.forEach((key, value) {
              selectedList.add(value);
            });
            return data.isEmpty
                ? Text('No Service Available')
                : Form(
              key: _formKey,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedList.length,
                  itemBuilder: (c, index) =>
                      getSelectedServiceItem(selectedList, index)),
            );
          }),
        ],
      ),
    );
  }

  getAvailableServiceItem(List<ModelService> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: MyColors.yellow,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item[index].name.toString()),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text('₹' + item[index].amount.toString()),
            ),
            Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      item[index].setBool(!item[index].isSelected);
                      ref.refresh(serviceNotifierProvider);
                      Map<String, ModelService> mMap = {};
                      for (var element in item) {
                        mMap[element.id] = element;
                      }
                      ref.read(serviceNotifierProvider.notifier).state = mMap;
                      item[index].isSelected
                          ? ref
                              .read(selectedServiceNotifierProvider.notifier)
                              .addService(item[index])
                          : ref
                              .read(selectedServiceNotifierProvider.notifier)
                              .removeService(item[index]);
                    },
                    child: item[index].isSelected
                        ? Icon(Icons.clear)
                        : Icon(Icons.add)))
          ],
        ),
      ),
    );
  }

  getSelectedServiceItem(List<ModelService> item, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Container(
          decoration: BoxDecoration(
              color: MyColors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item[index].name.toString(),
                        style: MyTextStyle.button1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        controller:
                            TextEditingController(text: item[index].amount),
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: item[index].configurable,
                        decoration: new InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: () {
                            if (item[index].isCustom == null) {
                              var data = ref
                                  .read(serviceNotifierProvider.notifier)
                                  .state;
                              data[item[index].id]!.setBool(false);
                              ref.refresh(serviceNotifierProvider);
                              ref.read(serviceNotifierProvider.notifier).state =
                                  data;
                            }

                            ref
                                .read(selectedServiceNotifierProvider.notifier)
                                .removeService(item[index]);
                          },
                          child: Icon(Icons.delete)))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Consumer(builder: (context, ref, child) {
                  List<ModelSelectedSubCategory> dropDownList = [];
                  dropDownList =
                      ref.read(selectedSubCategoryStateProvider.notifier).state;
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                            items: dropDownList
                                .map((e) => DropdownMenuItem<String>(
                                      value: e.id,
                                      child: Text(e.name!),
                                    ))
                                .toList(),
                            hint: Text('Select Category'),
                            isExpanded: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0))),
                            onChanged: (val) {
                              ref.read(serviceDropDownItem.notifier).state =
                                  val!;
                              item[index].setSubCategory(val);
                            }),
                      ),
                    ],
                  );
                }),
              )
            ],
          )),
    );
  }
}
