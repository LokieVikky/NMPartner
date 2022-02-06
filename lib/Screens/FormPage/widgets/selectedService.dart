import 'package:partner/provider/form_provider.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedService extends StatefulWidget {
  final selectedService;

  SelectedService({this.selectedService});

  @override
  _SelectedServiceState createState() => _SelectedServiceState();
}

class _SelectedServiceState extends State<SelectedService> {
  bool _selected = false;
  String selectedService = "";

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context, listen: false);

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        setState(() {
          _selected = !_selected;
          selectedService = widget.selectedService;
          if (_selected) {
            formProvider.shopTypeAdd(selectedService);
          } else {
            formProvider.shopTypeRemove(selectedService);
          }
        });
      },
      child: Container(
        height: _height / 10,
        width: _width / 3.8,
        margin: EdgeInsets.only(
          top: 20.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          color: _selected ? MyColors.purple : MyColors.purewhite,
        ),
        child: Center(
          child: Text(
            widget.selectedService,
            textAlign: TextAlign.center,
            style: _selected
                ? MyTextStyle.formContainerSelected
                : MyTextStyle.formContainerNotSelected,
          ),
        ),
      ),
    );
  }
}
