import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: OpenStreetMapSearchAndPick(
          center: LatLong(23, 89),
          buttonColor: Colors.blue,
          buttonText: 'Set this location',
          onPicked: (PickedData pickedData) {
            Navigator.of(context).pop(pickedData);
          }),
    );
  }
}
