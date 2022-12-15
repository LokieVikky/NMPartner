import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final bottomNavigationState = StateProvider<int>((ref) => 0);

final orderStatusDropdownItem = StateProvider<String>((ref) => '');

final serviceDropDownItem = StateProvider<String>((ref)=> 'Select Category');

final markerProvider = StateProvider<LatLng>((ref) => LatLng(13.0827, 80.2707));
