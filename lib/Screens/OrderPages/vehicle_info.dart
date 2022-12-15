import 'package:partner/values/MyColors.dart';
import 'package:partner/values/MyTextstyle.dart';
import 'package:flutter/material.dart';

class VehicleInfo extends StatelessWidget {
  VehicleInfo({required this.vehicle, required this.value});

  final String vehicle, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 5.0,
      ),
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                vehicle,
                style: MyTextStyle.text4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: MyTextStyle.text5,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

// Container(
//       padding: EdgeInsets.only(
//         left: 100.0,
//         right: 30.0,
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 alignment: Alignment.centerLeft,
//                 height: 25,
//                 width: 25,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 2,
//                     color: MyColors.purple1,
//                   ),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.check,
//                     size: 20,
//                   ),
//                 ),
//               ),
//               Text(
//                 vehicle,
//                 style: MyTextStyle.text4,
//               ),
//             ],
//           ),
//           SizedBox(
//             width: 10.0,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 value,
//                 style: MyTextStyle.text5,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
